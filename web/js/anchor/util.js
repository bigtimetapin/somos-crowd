import {Program, AnchorProvider, web3} from "@project-serum/anchor";
import {NETWORK, COMMITMENT, PROGRAM_ID} from "./config.js";
import {EphemeralWallet, PhantomWallet} from "./wallet";
import idl from "./idl.json";

// TODO; rename & move stuff
export const textEncoder = new TextEncoder();
export const textDecoder = new TextDecoder();
export const connection = new web3.Connection(NETWORK, COMMITMENT);
export const mplPrefix = "metadata";
export const mplEdition = "edition";
export const mplProgramId = new web3.PublicKey("metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s");
export const splTokenProgramId = new web3.PublicKey('TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA');
export const splAssociatedTokenProgramId = new web3.PublicKey('ATokenGPvbdGVxr1b2hvZbsiqW5xWH25efTNsLJA8knL');

// get provider & program
export function getPP(_phantom) {
    // build wallet
    const wallet = new PhantomWallet(_phantom);
    // set provider
    const provider = new AnchorProvider(connection, wallet, COMMITMENT);
    // program
    const program = new Program(idl, PROGRAM_ID, provider);
    return {provider: provider, program: program}
}

// get ephemeral provider & program
export function getEphemeralPP(){
    // build wallet
    const wallet = new EphemeralWallet();
    // set provider
    const provider = new AnchorProvider(connection, wallet, COMMITMENT);
    // program
    const program = new Program(idl, PROGRAM_ID, provider);
    return {provider: provider, program: program}
}

export function encodeBase64(u8) {
    return Buffer.from(u8).toString('base64')
}

export function decodeBase64(b64) {
    return new Uint8Array(Buffer.from(b64, 'base64'))
}
