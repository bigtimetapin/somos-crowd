import {web3} from "@project-serum/anchor";

export async function getAuthorityPda(program, handle, index) {
    const pda = await deriveAuthorityPda(program, handle, index);
    const authority = await program.account.authority.fetch(pda);
    console.log(authority);
    return {
        // meta
        name: authority.name,
        symbol: authority.symbol,
        index: index,
        // for other pda derivations
        mint: authority.mint,
        collection: authority.collection,
        numMinted: authority.numMinted,
        // pda for program invocation
        pda: pda
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
