import {getPhantom} from "./phantom";
import {creatNft} from "./anchor/init/init";
import {getPP} from "./anchor/util";
import {deriveCreatorPda} from "./anchor/pda/derive-creator-pda";

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
        if (sender === "creator-authorize-handle") {
            // get phantom
            phantom = await getPhantom();
            const publicKey = phantom.connection.publicKey.toString();
            // get provider & program
            const pp = getPP(phantom);
            // parse more json
            const more = JSON.parse(parsed.more);
            // derive creator-pda
            const creator = await deriveCreatorPda(pp.provider, pp.program, more.handle);
            // authorize
            if (publicKey === creator.authority) {
                app.ports.success.send(
                    JSON.stringify(
                        {
                            listener: "creator-handle-authorized",
                            more: JSON.stringify(
                                {
                                    handle: more.handle,
                                    wallet: publicKey
                                }
                            )
                        }
                    )
                );
            } else {
                app.ports.success.send(
                    JSON.stringify(
                        {
                            listener: "creator-handle-unauthorized",
                            more: JSON.stringify(
                                {
                                    handle: more.handle,
                                    wallet: publicKey
                                }
                            )
                        }
                    )
                );
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
