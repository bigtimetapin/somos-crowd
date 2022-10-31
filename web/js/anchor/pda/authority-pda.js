import {web3} from "@project-serum/anchor";

export async function getAuthorityPda(program, handle, index) {
    const pda = await deriveAuthorityPda(program, handle, index);
    const authority = await program.account.authority.fetch(pda);
    console.log(authority);
    return {
        name: authority.name,
        symbol: authority.symbol,
        index: index,
        numMinted: authority.numMinted
    }
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
