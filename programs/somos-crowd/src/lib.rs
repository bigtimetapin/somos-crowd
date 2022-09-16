use anchor_lang::prelude::*;
use anchor_spl::token::{Mint, Token};
use mpl_token_metadata::state::{PREFIX, MAX_METADATA_LEN};
use mpl_token_metadata::instruction::create_metadata_accounts_v3;

declare_id!("HRLqhFshmXMXZmY1Fkz8jJTktMEkoxLssFDtydkW5xXa");

#[program]
pub mod somos_crowd {
    use super::*;

    pub fn initialize_collection(
        ctx: Context<InitializeCollection>,
    ) -> Result<()> {
        // build instruction
        let ix = create_metadata_accounts_v3(
            mpl_token_metadata::ID,
            ctx.accounts.metadata.key(),
            ctx.accounts.mint.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.payer.key(),
            ctx.accounts.authority.key(),
            String::from("test-name"),
            String::from("test-symbol"),
            String::from("test-uri"),
            None,
            500,
            false,
            false,
            None,
            None,
            None
        );
        // unwrap authority bump
        let authority_bump = *ctx.bumps.get("authority").unwrap();
        // build signer seeds
        let seeds = &[
            "authority".as_bytes(), &ctx.accounts.mint.key().to_bytes(),
            &[authority_bump]
        ];
        let signer_seeds = &[&seeds[..]];
        // invoke
        anchor_lang::solana_program::program::invoke_signed(
            &ix,
            &[
                ctx.accounts.metadata.to_account_info()
            ],
            signer_seeds
        ).map_err(Into::into)
    }

}

////////////////////////////////////////////////////////////////////////////////////////////////////
// Impl ////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#[derive(Accounts)]
pub struct InitializeCollection<'info> {
    #[account(init,
    seeds = [b"authority", mint.key().as_ref()], bump,
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
    mint.key().as_ref()
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
