import {web3} from "@project-serum/anchor";

export const COMMITMENT = "processed";
export const PROGRAM_ID = new web3.PublicKey("HRLqhFshmXMXZmY1Fkz8jJTktMEkoxLssFDtydkW5xXa");

// const localnet = "http://127.0.0.1:8899";
// const devnet = web3.clusterApiUrl("devnet");
const mainnet = web3.clusterApiUrl("mainnet-beta");
export const NETWORK = mainnet;
