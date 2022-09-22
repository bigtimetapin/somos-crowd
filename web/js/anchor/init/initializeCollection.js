import {web3} from "@project-serum/anchor";
import {mplEdition, mplPrefix, mplProgramId, splTokenProgramId} from "../util";

export async function initializeCollection(provider, program, json) {
    // get user wallet
    const publicKey = provider.wallet.publicKey.toString();
    // parse uploader
    const parsed = JSON.parse(json);
    // derive new key-pair for collection
    const collection = web3.Keypair.generate();
    // derive authority
    let authority, _;
    [authority, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from("authority"),
            collection.publicKey.toBuffer()
        ],
        program.programId
    );
    // derive metadata
    let metadata;
    [metadata, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from(mplPrefix),
            mplProgramId.toBuffer(),
            collection.publicKey.toBuffer(),
        ],
        mplProgramId
    )
    // derive master-edition
    let masterEdition;
    [masterEdition, _] = await web3.PublicKey.findProgramAddress(
        [
            Buffer.from(mplPrefix),
            mplProgramId.toBuffer(),
            collection.publicKey.toBuffer(),
            Buffer.from(mplEdition),
        ],
        mplProgramId
    )
    // invoke rpc
    await program.methods
        .createCollection(
            parsed.name,
            parsed.symbol,
            "test-uri"
        )
        .accounts(
            {
                authority: authority,
                collection: collection.publicKey,
                metadata: metadata,
                masterEdition: masterEdition,
                payer: provider.wallet.publicKey,
                tokenProgram: splTokenProgramId,
                metadataProgram: mplProgramId,
                systemProgram: web3.SystemProgram.programId,
                rent: web3.SYSVAR_RENT_PUBKEY,
            }
        )
        .signers([collection])
        .rpc()
    // fetch pda
    console.log(collection.publicKey.toString());
    console.log(masterEdition.toString());
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