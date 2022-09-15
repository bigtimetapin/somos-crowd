use anchor_lang::prelude::*;
use anchor_spl::token::{Mint, Token};
use mpl_token_metadata::state::{PREFIX, MAX_METADATA_LEN};

declare_id!("HRLqhFshmXMXZmY1Fkz8jJTktMEkoxLssFDtydkW5xXa");

#[program]
pub mod somos_crowd {
    use super::*;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// Impl ////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#[derive(Accounts)]
pub struct InitializeCollection<'info> {
    #[account(init,
    seeds = [b"authority"], bump,
    payer = payer,
    space = Authority::SPACE
    )]
    pub authority: Account<'info, Authority>,
    #[account(init,
    mint::authority = authority,
    mint::decimals = 0,
    payer = payer
    )]
    pub mint: Account<'info, Mint>,
    #[account(init,
    seeds = [
    PREFIX.as_bytes(),
    mpl_token_metadata::ID.as_ref(),
    mint.to_account_info().key().as_ref()
    ], bump,
    payer = payer,
    space = MAX_METADATA_LEN,
    owner = mpl_token_metadata::ID
    )]
    /// CHECK: Metaplex-metadata; TODO consider deser impl
    pub metadata: UncheckedAccount<'info>,
    #[account(mut)]
    pub payer: Signer<'info>,
    // token program
    pub token_program: Program<'info, Token>,
    // system program
    pub system_program: Program<'info, System>,
    // rent program
    pub rent: Sysvar<'info, Rent>,
}

#[account]
pub struct Authority {
    pub collection: Pubkey,
}

impl Authority {
    const SPACE: usize = 8 + 32;
}

#[error_code]
pub enum CustomErrors {
    #[msg("decentralized assets should be immutable.")]
    ImmutableAssets,
}
