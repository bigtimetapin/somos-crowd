import {getPhantom} from "./phantom";
import {initializeCollection} from "./anchor/init/initializeCollection";
import {getPP} from "./anchor/util";

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
        if (sender === "creator-connect") {
            // get phantom
            phantom = await getPhantom();
            const publicKey = phantom.connection.publicKey.toString();
            // send to elm
            app.ports.success.send(
                JSON.stringify(
                    {
                        listener: "creator-connect-success",
                        more: JSON.stringify(
                            {
                                wallet: publicKey
                            }
                        )
                    }
                )
            );
            // or creator initialize collection
        } else if (sender === "creator-initialize-collection") {
            // get provider & program
            const pp = getPP(phantom);
            // invoke rpc
            await initializeCollection(pp.provider, pp.program, parsed.more);
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
