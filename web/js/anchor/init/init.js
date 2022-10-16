import {web3, BN} from "@project-serum/anchor";
import {mplEdition, mplPrefix, mplProgramId, splAssociatedTokenProgramId, splTokenProgramId} from "../util";
import {deriveCreatorPda, getCreatorPda} from "../pda/creator-pda";
import {deriveAuthorityPda, getAuthorityPda} from "../pda/authority-pda";
import {getCreatorCollections} from "../get-creator-collections";

export async function creatNft(provider, program, handle, name, symbol) {
    try {
        // get user wallet
        const publicKey = provider.wallet.publicKey.toString();
        // get creator
        const creatorPda = await deriveCreatorPda(program, handle);
        const creator = await getCreatorPda(program, creatorPda);
        // derive authority pda
        const authorityIndex = creator.numCollections + 1;
        const authorityPda = await deriveAuthorityPda(program, handle, authorityIndex);
        // derive key-pair for mint
        const mint = web3.Keypair.generate();
        // derive metadata
        let metadata, _;
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
                authorityPda.toBuffer(),
                splTokenProgramId.toBuffer(),
                mint.publicKey.toBuffer()
            ],
            splAssociatedTokenProgramId
        )
        // invoke rpc
        await program.methods
            .createNft(
                name,
                symbol,
                "test-uri",
                new BN(2) // TODO; supply
            )
            .accounts(
                {
                    creator: creatorPda,
                    authority: authorityPda,
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
        console.log("creator: " + creatorPda.toString());
        console.log("authority: " + authorityPda.toString());
        console.log("mint: " + mint.publicKey.toString());
        // invoke create-collection
        await createCollection(
            provider, program, creatorPda, authorityPda, mint.publicKey
        );
        // get collections TODO; fetch fetch creator pda
        const collections = await getCreatorCollections(program, creator);
        console.log(collections)
        app.ports.success.send(
            JSON.stringify(
                {
                    listener: "creator-authorized",
                    more: JSON.stringify(
                        {
                            handle: handle,
                            wallet: publicKey,
                            collections: collections
                        }
                    )
                }
            )
        );
    } catch (error) {
        console.log(error.toString())
        app.ports.error.send(
            error.toString()
        )
    }
}

async function createCollection(provider, program, creator, authority, mint) {
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
                creator: creator,
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
    let n = (await getAuthorityPda(program, authority)).numMinted + 1;
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
                tokenProgram: splTokenProgramId,
                associatedTokenProgram: splAssociatedTokenProgramId,
                metadataProgram: mplProgramId,
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
                tokenProgram: splTokenProgramId,
                metadataProgram: mplProgramId,
                systemProgram: web3.SystemProgram.programId,
                rent: web3.SYSVAR_RENT_PUBKEY,
            }
        ).rpc()
}