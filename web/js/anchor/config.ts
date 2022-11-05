import {clusterApiUrl, PublicKey} from "@solana/web3.js";


export const COMMITMENT = "processed";
export const PROGRAM_ID = new PublicKey("HRLqhFshmXMXZmY1Fkz8jJTktMEkoxLssFDtydkW5xXa");

// const localnet = "http://127.0.0.1:8899";
// const devnet = clusterApiUrl("devnet");
const mainnet = clusterApiUrl("mainnet-beta");
export const NETWORK = mainnet;
