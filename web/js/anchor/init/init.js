import {web3, BN} from "@project-serum/anchor";
import {mplEdition, mplPrefix, mplProgramId, splAssociatedTokenProgramId, splTokenProgramId} from "../util";

export async function creatNft(provider, program, json) {
    // get user wallet
    const publicKey = provider.wallet.publicKey.toString();
    // parse uploader
    const parsed = JSON.parse(json);
    // derive key-pair for mint
    const mint = web3.Keypair.generate()
    // derive authority
    let authority, _;
    [authority, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from("authority"),
            mint.publicKey.toBuffer()
        ],
        program.programId
    );
    // derive metadata
    let metadata;
    [metadata, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from(mplPrefix),
            mplProgramId.toBuffer(),
            mint.publicKey.toBuffer(),
        ],
        mplProgramId
    )
    // derive master-edition
    let masterEdition;
    [masterEdition, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from(mplPrefix),
            mplProgramId.toBuffer(),
            mint.publicKey.toBuffer(),
            Buffer.from(mplEdition),
        ],
        mplProgramId
    )
    // derive master-edition-ata
    let masterEditionAta;
    [masterEditionAta, _] = await web3.PublicKey.findProgramAddress(
        [
            authority.toBuffer(),
            splTokenProgramId.toBuffer(),
            mint.publicKey.toBuffer()
        ],
        splAssociatedTokenProgramId
    )
    // invoke rpc
    await program.methods
        .createNft(
            parsed.name,
            parsed.symbol,
            "test-uri",
            new BN(100)
        )
        .accounts(
            {
                authority: authority,
                mint: mint.publicKey,
                metadata: metadata,
                masterEdition: masterEdition,
                masterEditionAta: masterEditionAta,
                payer: provider.wallet.publicKey,
                tokenProgram: splTokenProgramId,
                associatedTokenProgram: splAssociatedTokenProgramId,
                metadataProgram: mplProgramId,
                systemProgram: web3.SystemProgram.programId,
                rent: web3.SYSVAR_RENT_PUBKEY,
            }
        )
        .signers([mint])
        .rpc()
    // fetch pda
    console.log(mint.publicKey.toString());
    // invoke create-collection
    const collection = await createCollection(provider, program, authority, mint.publicKey);
    // invoke new copy
    await printNewCopy(
        provider,
        program,
        authority,
        mint.publicKey,
        metadata,
        masterEdition,
        masterEditionAta
    );
    await printNewCopy(
        provider,
        program,
        authority,
        mint.publicKey,
        metadata,
        masterEdition,
        masterEditionAta
    );
    // build success
    const success = {
        listener: "creator-initialize-collection-success",
        more: JSON.stringify(
            {
                wallet: publicKey,
                name: parsed.name,
                symbol: parsed.symbol
            }
        )
    }
    // send success to elm
    app.ports.success.send(JSON.stringify(success));
}

async function createCollection(provider, program, authority, mint) {
    // derive key-pair for collection
    const collection = web3.Keypair.generate();
    // derive collection metadata
    let collectionMetadata, _;
    [collectionMetadata, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from(mplPrefix),
            mplProgramId.toBuffer(),
            collection.publicKey.toBuffer(),
        ],
        mplProgramId
    )
    // derive collection master-edition
    let collectionMasterEdition;
    [collectionMasterEdition, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from(mplPrefix),
            mplProgramId.toBuffer(),
            collection.publicKey.toBuffer(),
            Buffer.from(mplEdition),
        ],
        mplProgramId
    )
    // derive collection master-edition-ata
    let collectionMasterEditionAta;
    [collectionMasterEditionAta, _] = await web3.PublicKey.findProgramAddress(
        [
            authority.toBuffer(),
            splTokenProgramId.toBuffer(),
            collection.publicKey.toBuffer()
        ],
        splAssociatedTokenProgramId
    )
    // invoke rpc
    await program.methods
        .createCollection()
        .accounts(
            {
                authority: authority,
                mint: mint,
                collection: collection.publicKey,
                collectionMetadata: collectionMetadata,
                collectionMasterEdition: collectionMasterEdition,
                collectionMasterEditionAta: collectionMasterEditionAta,
                payer: provider.wallet.publicKey,
                tokenProgram: splTokenProgramId,
                associatedTokenProgram: splAssociatedTokenProgramId,
                metadataProgram: mplProgramId,
                systemProgram: web3.SystemProgram.programId,
                rent: web3.SYSVAR_RENT_PUBKEY,
            }
        )
        .signers([collection])
        .rpc()
    console.log(collection.publicKey.toString());
    return {mint: collection.publicKey, metadata: collectionMetadata, masterEdition: collectionMasterEdition}
}

async function printNewCopy(
    provider,
    program,
    authority,
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
            Buffer.from(mplPrefix),
            mplProgramId.toBuffer(),
            newMint.publicKey.toBuffer(),
        ],
        mplProgramId
    )
    // derive new-edition
    let newEdition;
    [newEdition, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from(mplPrefix),
            mplProgramId.toBuffer(),
            newMint.publicKey.toBuffer(),
            Buffer.from(mplEdition),
        ],
        mplProgramId
    )
    // derive new-edition-mark
    let n = (await program.account.authority.fetch(authority)).numMinted + 1;
    const newEditionBN = new BN.BN(n);
    const newEditionMarkLiteral = newEditionBN.div(new BN.BN(248)).toString();
    let newEditionMark;
    [newEditionMark, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from(mplPrefix),
            mplProgramId.toBuffer(),
            mint.toBuffer(),
            Buffer.from(mplEdition),
            Buffer.from(newEditionMarkLiteral)
        ],
        mplProgramId
    )
    // derive new-edition-ata
    let newEditionAta;
    [newEditionAta, _] = await web3.PublicKey.findProgramAddress(
        [
            provider.wallet.publicKey.toBuffer(),
            splTokenProgramId.toBuffer(),
            newMint.publicKey.toBuffer()
        ],
        splAssociatedTokenProgramId
    )
    // invoke rpc
    await program.methods
        .mintNewCopy()
        .accounts(
            {
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
                tokenProgram: splTokenProgramId,
                associatedTokenProgram: splAssociatedTokenProgramId,
                metadataProgram: mplProgramId,
                systemProgram: web3.SystemProgram.programId,
                rent: web3.SYSVAR_RENT_PUBKEY,
            }
        ).signers([newMint])
        .rpc()
    console.log(newMint.publicKey.toString());
}