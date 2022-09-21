import {web3} from "@project-serum/anchor";
import {mplPrefix, mplProgramId, splTokenProgramId} from "../util";

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
    // invoke rpc
    await program.methods
        .initializeCollection()
        .accounts(
            {
                authority: authority,
                collection: collection.publicKey,
                metadata: metadata,
                payer: provider.wallet.publicKey,
                tokenProgram: splTokenProgramId,
                systemProgram: web3.SystemProgram.programId,
                rent: web3.SYSVAR_RENT_PUBKEY,
            },
            [collection]
        )
        .rpc()
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