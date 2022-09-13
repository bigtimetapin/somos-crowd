import {getPhantom} from "./phantom";

// init phantom
let phantom = null;
//  listen for sender
app.ports.sender.subscribe(async function (json) {
    try {
        // parse json as object
        const sender = JSON.parse(json);
        // match on sender role
        const role = sender.sender;
        if (role === "creator-connect") {
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
        }
    } catch (error) {
        app.ports.error.send(
            error.toString()
        );
    }
});
