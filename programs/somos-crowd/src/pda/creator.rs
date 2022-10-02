use anchor_lang::prelude::*;

pub const SIZE: usize = 8 // discriminator
    + HANDLE_SIZE
    + AUTHORITY_SIZE
    + NUM_COLLECTIONS_SIZE
    + HIGHLIGHTED_SIZE;

pub const MAX_HANDLE_LENGTH: usize = 16;

const HANDLE_SIZE: usize = 4 + MAX_HANDLE_LENGTH;

const AUTHORITY_SIZE: usize = 32;

const NUM_COLLECTIONS_SIZE: usize = 1;

const HIGHLIGHTED_SIZE: usize = 10;


#[account]
pub struct Creator {
    pub handle: String,
    pub authority: Pubkey, // TODO; [as NFT, assert]
    pub num_collections: u8,
    pub highlighted: Highlighted,
}

#[derive(AnchorSerialize, AnchorDeserialize, Clone, Copy)]
pub struct Highlighted {
    pub collections: [u8; 10],
}
