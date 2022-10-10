import {getPhantom} from "./phantom";
import {creatNft} from "./anchor/init/init";
import {getEphemeralPP, getPP} from "./anchor/util";
import {validateHandle, assertCreatorPdaDoesNotExistAlready} from "./anchor/pda/creator-pda";
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
            const validated = validateHandle(more.handle);
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
                    console.log(validated);
                    console.log(creator);
                    console.log(pp.provider.connection._blockhashInfo);
                    await initNewCreator(pp.provider, pp.program, validated, creator);
                    console.log(pp.provider.connection._blockhashInfo);
                }
            }
            // or creator initialize collection
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
