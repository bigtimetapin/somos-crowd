import {getPhantom} from "./phantom";
import {creatNft} from "./anchor/init/init";
import {getEphemeralPP, getPP} from "./anchor/util";
import {
    validateHandleForNewCreator,
    validateHandleForExistingCreator,
    assertCreatorPdaDoesNotExistAlready,
    assertCreatorPdaDoesExistAlready
} from "./anchor/pda/creator-pda";
import {initNewCreator} from "./anchor/init-new-creator";

// init phantom
let phantom = null;
//  listen for sender
app.ports.sender.subscribe(async function (json) {
    try {
        // parse json as object
        const parsed = JSON.parse(json);
        // match on sender role
        const sender = parsed.sender;
        // creator connect
        if (sender === "new-creator-confirm-handle") {
            // parse more json
            const more = JSON.parse(parsed.more);
            // validate handle
            const validated = validateHandleForNewCreator(more.handle);
            if (validated) {
                // get ephemeral provider & program
                const ephemeralPP = getEphemeralPP();
                // assert creator pda does-not-exist
                const creator = await assertCreatorPdaDoesNotExistAlready(
                    ephemeralPP.provider,
                    ephemeralPP.program,
                    validated
                );
                // create pda
                if (creator) {
                    // get phantom
                    phantom = await getPhantom();
                    // get provider & program
                    const pp = getPP(phantom);
                    // invoke init-new-creator
                    await initNewCreator(pp.provider, pp.program, validated, creator);
                }
            }
            // or creator initialize collection
        } else if (sender === "existing-creator-confirm-handle") {
            // parse more json
            const more = JSON.parse(parsed.more);
            // validate handle
            const validated = validateHandleForExistingCreator(more.handle);
            if (validated) {
                // get ephemeral provider & program
                const ephemeralPP = getEphemeralPP();
                // asert creator pda exists
                const creator = await assertCreatorPdaDoesExistAlready(
                    ephemeralPP.provider,
                    ephemeralPP.program,
                    validated
                )
                // authorize pda
                if (creator) {
                    // get phantom
                    phantom = await getPhantom();
                    // get provider & program
                    const pp = getPP(phantom);
                    // assert authority is current user
                    const current = pp.provider.wallet.publicKey.toString()
                    if (creator.authority.toString() === current) {
                        console.log("user authorized");
                        app.ports.success.send(
                            JSON.stringify(
                                {
                                    listener: "creator-handle-authorized",
                                    more: JSON.stringify(
                                        {
                                            handle: validated,
                                            wallet: current
                                        }
                                    )
                                }
                            )
                        );
                    } else {
                        console.log("user unauthorized");
                        app.ports.success.send(
                            JSON.stringify(
                                {
                                    listener: "creator-handle-unauthorized",
                                    more: JSON.stringify(
                                        {
                                            handle: validated,
                                            wallet: current
                                        }
                                    )
                                }
                            )
                        );
                    }
                }
            }
        } else if (sender === "creator-initialize-collection") {
            // get provider & program
            const pp = getPP(phantom);
            // invoke rpc
            await creatNft(pp.provider, pp.program, parsed.more);
            // or throw error
        } else {
            const msg = "invalid role sent to js: " + sender;
            app.ports.error.send(
                msg
            );
        }
    } catch (error) {
        console.log(error);
        app.ports.error.send(
            error.toString()
        );
    }
});
