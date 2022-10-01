use anchor_lang::prelude::*;

pub const SEED: &str = "authority";

pub const SIZE: usize = 8 // discriminator
    + MINT_SIZE
    + COLLECTION_SIZE
    + NUM_MINTED
    + TOTAL_SUPPLY;

const MINT_SIZE: usize = 32;

const COLLECTION_SIZE: usize = 32;

const NUM_MINTED: usize = 8;

const TOTAL_SUPPLY: usize = 8;

#[account]
pub struct Authority {
    pub mint: Pubkey,
    pub collection: Pubkey,
    pub num_minted: u64,
    pub total_supply: u64,
}
