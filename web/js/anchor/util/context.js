import {EphemeralWallet, PhantomWallet} from "../wallet";
import {AnchorProvider, Program, web3} from "@project-serum/anchor";
import {COMMITMENT, NETWORK, PROGRAM_ID} from "../config";
import idl from "../idl.json";

// get provider & program
export function getPP(_phantom) {
    // build wallet
    const wallet = new PhantomWallet(_phantom);
    // set provider
    const connection = new web3.Connection(NETWORK, COMMITMENT);
    const provider = new AnchorProvider(connection, wallet, AnchorProvider.defaultOptions());
    // program
    const program = new Program(idl, PROGRAM_ID, provider);
    return {provider: provider, program: program}
}

// get ephemeral provider & program
export function getEphemeralPP(){
    const keypair = web3.Keypair.generate();
    // build wallet
    const wallet = new EphemeralWallet(keypair);
    // set provider
    const connection = new web3.Connection(NETWORK, COMMITMENT);
    const provider = new AnchorProvider(connection, wallet, AnchorProvider.defaultOptions());
    // program
    const program = new Program(idl, PROGRAM_ID, provider);
    return {provider: provider, program: program}
}
