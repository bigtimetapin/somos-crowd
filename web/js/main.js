import {getPhantom} from "./phantom";
import {getEphemeralPP, getPP} from "./anchor/util/context";
import {
    validateHandleForNewCreator,
    validateHandleForExistingCreator,
    assertCreatorPdaDoesNotExistAlready,
    assertCreatorPdaDoesExistAlready
} from "./anchor/pda/creator-pda";
import {getCreatorCollections} from "./anchor/pda/get-creator-collections";
import {initNewCreator} from "./anchor/methods/init-new-creator";
import {creatNft} from "./anchor/methods/create-nft";

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
                        // get collections; TODO method
                        const collections = await getCreatorCollections(pp.program, creator);
                        console.log(collections)
                        console.log(
                            JSON.stringify(
                                {
                                    listener: "creator-authorized",
                                    more: JSON.stringify(
                                        {
                                            handle: validated,
                                            wallet: current,
                                            collections: collections
                                        }
                                    )
                                }
                            )
                        )
                        app.ports.success.send(
                            JSON.stringify(
                                {
                                    listener: "creator-authorized",
                                    more: JSON.stringify(
                                        {
                                            handle: validated,
                                            wallet: current,
                                            collections: collections
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
        } else if (sender === "creator-create-new-collection") {
            // get provider & program
            const pp = getPP(phantom);
            // parse more json
            const more = JSON.parse(parsed.more);
            // invoke rpc
            await creatNft(pp.provider, pp.program, more.handle, more.name, more.symbol);
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
