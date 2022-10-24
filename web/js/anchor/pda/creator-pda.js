import {web3} from "@project-serum/anchor";

export async function deriveCreatorPda(program, handle) {
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

export async function getCreatorPda(program, pda) {
    return await program.account.creator.fetch(pda);
}

export async function assertCreatorPdaDoesNotExistAlready(program, handle) {
    // derive pda
    const pda = await deriveCreatorPda(program, handle);
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

export async function assertCreatorPdaDoesExistAlreadyForCreator(program, handle) {
    return await assertCreatorPdaDoesExistAlready(program, handle, "creator-handle-dne")
}

export async function assertCreatorPdaDoesExistAlreadyForCollector(program, handle) {
    return await assertCreatorPdaDoesExistAlready(program, handle, "collector-handle-dne")
}

async function assertCreatorPdaDoesExistAlready(program, handle, listener) {
    // derive pda
    const pda = await deriveCreatorPda(program, handle);
    // fetch pda
    let creator;
    try {
        creator = await getCreatorPda(program, pda);
        const msg = "found handle: " + handle;
        console.log(msg);
    } catch (error) {
        const msg = "handle does not exist yet: " + handle;
        console.log(msg);
        app.ports.success.send(
            JSON.stringify(
                {
                    listener: "creator-handle-dne",
                    more: JSON.stringify(handle)
                }
            )
        );
        creator = null;
    }
    return creator
}

export function validateHandleForNewCreator(handle) {
    return validateHandle(handle, "new-creator-handle-invalid")
}

export function validateHandleForExistingCreator(handle) {
    return validateHandle(handle, "existing-creator-handle-invalid")
}

export function validateHandleForCollector(handle) {
    return validateHandle(handle, "collector-handle-invalid")
}

function validateHandle(handle, listener) {
    if (isValidHandle(handle)) {
        return handle
    } else {
        const msg = "invalid handle: " + handle;
        console.log(msg);
        app.ports.success.send(
            JSON.stringify(
                {
                    listener: listener,
                    more: JSON.stringify(handle)
                }
            )
        );
        return null
    }
}

function isValidHandle(handle) {
    return (handle.length <= 16)
}
