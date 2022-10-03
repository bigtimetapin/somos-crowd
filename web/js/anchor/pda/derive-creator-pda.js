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
