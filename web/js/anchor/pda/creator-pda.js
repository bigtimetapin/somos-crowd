import {web3} from "@project-serum/anchor";

export async function deriveCreatorPda(provider, program, handle) {
    // derive pda
    let pda, _;
    [pda, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from(handle)
        ],
        program.programId
    );
    return pda
}

export async function assertCreatorPdaDoesNotExistAlready(provider, program, handle) {
    // derive pda
    const pda = await deriveCreatorPda(provider, program, handle)
    // fetch pda
    let creator;
    try {
        await getCreatorPda(program, pda);
        const msg = "handle exists already: " + handle;
        console.log(msg);
        app.ports.success.send(
            JSON.stringify(
                {
                    listener: "creator-handle-already-exists",
                    more: JSON.stringify(handle)
                }
            )
        );
        creator = null;
    } catch (error) {
        const msg = "handle is still available: " + handle;
        console.log(msg);
        creator = pda;
    }
    return creator
}

export function validateHandle(handle) {
    if (isValidHandle(handle)) {
        return handle
    } else {
        const msg = "invalid handle: " + handle;
        console.log(msg);
        app.ports.success.send(
            JSON.stringify(
                {
                    listener: "new-creator-invalid-handle",
                    more: JSON.stringify(handle)
                }
            )
        );
        return null
    }
}

async function getCreatorPda(program, pda) {
    return await program.account.creator.fetch(pda);
}

function isValidHandle(handle) {
    return (handle.length <= 16)
}
