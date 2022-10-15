import {web3} from "@project-serum/anchor";

export async function getAuthorityPda(program, pda) {
    return await program.account.authority.fetch(pda);
}

export async function deriveAuthorityPda(program, handle, index) {
    console.log(index);
    // derive pda
    let pda, _;
    [pda, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from(handle),
            Buffer.from([index])
        ],
        program.programId
    );
    return pda
}
