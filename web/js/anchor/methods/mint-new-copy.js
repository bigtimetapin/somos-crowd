import {BN, web3} from "@project-serum/anchor";
import {getAuthorityPda} from "../pda/authority-pda";
import {
    MPL_PREFIX,
    MPL_EDITION,
    MPL_TOKEN_METADATA_PROGRAM_ID,
    SPL_TOKEN_PROGRAM_ID,
    SPL_ASSOCIATED_TOKEN_PROGRAM_ID
} from "../util/constants";

export async function mintNewCopy(
    provider,
    program,
    creator,
    authority,
    authorityIndex,
    mint,
    metadata,
    masterEdition,
    masterEditionAta
) {
    // derive key-pair for new-edition-mint
    const newMint = web3.Keypair.generate();
    // derive new-metadata
    let newMetadata, _;
    [newMetadata, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from(MPL_PREFIX),
            MPL_TOKEN_METADATA_PROGRAM_ID.toBuffer(),
            newMint.publicKey.toBuffer(),
        ],
        MPL_TOKEN_METADATA_PROGRAM_ID
    )
    // derive new-edition
    let newEdition;
    [newEdition, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from(MPL_PREFIX),
            MPL_TOKEN_METADATA_PROGRAM_ID.toBuffer(),
            newMint.publicKey.toBuffer(),
            Buffer.from(MPL_EDITION),
        ],
        MPL_TOKEN_METADATA_PROGRAM_ID
    )
    // derive new-edition-mark
    let handle; // TODO
    let n = (await getAuthorityPda(program, handle, authorityIndex)).numMinted + 1;
    const newEditionBN = new BN.BN(n);
    const newEditionMarkLiteral = newEditionBN.div(new BN.BN(248)).toString();
    let newEditionMark;
    [newEditionMark, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from(MPL_PREFIX),
            MPL_TOKEN_METADATA_PROGRAM_ID.toBuffer(),
            mint.toBuffer(),
            Buffer.from(MPL_EDITION),
            Buffer.from(newEditionMarkLiteral)
        ],
        MPL_TOKEN_METADATA_PROGRAM_ID
    )
    // derive new-edition-ata
    let newEditionAta;
    [newEditionAta, _] = await web3.PublicKey.findProgramAddress(
        [
            provider.wallet.publicKey.toBuffer(),
            SPL_TOKEN_PROGRAM_ID.toBuffer(),
            newMint.publicKey.toBuffer()
        ],
        SPL_ASSOCIATED_TOKEN_PROGRAM_ID
    )
    // invoke rpc
    await program.methods
        .mintNewCopy(authorityIndex)
        .accounts(
            {
                creator: creator,
                authority: authority,
                mint: mint,
                metadata: metadata,
                masterEdition: masterEdition,
                masterEditionAta: masterEditionAta,
                newMint: newMint.publicKey,
                newMetadata: newMetadata,
                newEdition: newEdition,
                newEditionMark: newEditionMark,
                newEditionAta: newEditionAta,
                payer: provider.wallet.publicKey,
                tokenProgram: SPL_TOKEN_PROGRAM_ID,
                associatedTokenProgram: SPL_ASSOCIATED_TOKEN_PROGRAM_ID,
                metadataProgram: MPL_TOKEN_METADATA_PROGRAM_ID,
                systemProgram: web3.SystemProgram.programId,
                rent: web3.SYSVAR_RENT_PUBKEY,
            }
        ).signers([newMint])
        .rpc()
    console.log(newMint.publicKey.toString());
    return {mint: newMint.publicKey, metadata: newMetadata}
}

async function addNewCopyToCollection(provider, program, creator, authority, authorityIndex, mint, collection, newCopy) {
    // invoke rpc
    await program.methods
        .addNewCopyToCollection(authorityIndex)
        .accounts(
            {
                creator: creator,
                authority: authority,
                mint: mint,
                collection: collection.mint,
                collectionMetadata: collection.metadata,
                collectionMasterEdition: collection.masterEdition,
                newMint: newCopy.mint,
                newMetadata: newCopy.metadata,
                payer: provider.wallet.publicKey,
                tokenProgram: SPL_TOKEN_PROGRAM_ID,
                metadataProgram: MPL_TOKEN_METADATA_PROGRAM_ID,
                systemProgram: web3.SystemProgram.programId,
                rent: web3.SYSVAR_RENT_PUBKEY,
            }
        ).rpc()
}