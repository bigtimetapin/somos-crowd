import {web3} from "@project-serum/anchor";
import {deriveCreatorPda} from "./pda/derive-creator-pda";

export async function initNewCreator(provider, program) {
    const handle = Math.random().toString(36).slice(0, 15);
    console.log(handle);
    console.log(handle.length);
    // derive pda
    const pda = await deriveCreatorPda(provider, program, handle);
    // invoke rpc
    await program.methods
        .initNewCreator(
            handle
        )
        .accounts(
            {
                creator: pda,
                payer: provider.wallet.publicKey,
                systemProgram: web3.SystemProgram.programId,
            }
        )
        .rpc()
    return {pda, handle}
}
