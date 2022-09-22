use anchor_lang::prelude::*;
use anchor_spl::token::{Mint, Token};
use mpl_token_metadata::state::PREFIX;
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
            ctx.accounts.metadata_program.key(),
            ctx.accounts.metadata.key(),
            ctx.accounts.collection.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.payer.key(),
            ctx.accounts.authority.key(),
            String::from("test-name"),
            String::from("TST"),
            String::from("test-uri"),
            None,
            500,
            false,
            false,
            None,
            None,
            None,
        );
        // unwrap authority bump
        let authority_bump = *ctx.bumps.get("authority").unwrap();
        // build signer seeds
        let seeds = &[
            "authority".as_bytes(), &ctx.accounts.collection.key().to_bytes(),
            &[authority_bump]
        ];
        let signer_seeds = &[&seeds[..]];
        // invoke
        anchor_lang::solana_program::program::invoke_signed(
            &ix,
            &[
                ctx.accounts.metadata.to_account_info(),
                ctx.accounts.collection.to_account_info(),
                ctx.accounts.authority.to_account_info(),
                ctx.accounts.payer.to_account_info(),
                ctx.accounts.authority.to_account_info(),
                ctx.accounts.system_program.to_account_info(),
                ctx.accounts.rent.to_account_info()
            ],
            signer_seeds,
        ).map_err(Into::into)
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// Impl ////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#[derive(Accounts)]
pub struct InitializeCollection<'info> {
    #[account(init,
    seeds = [b"authority", collection.key().as_ref()], bump,
    payer = payer,
    space = Authority::SPACE
    )]
    pub authority: Account<'info, Authority>,
    #[account(init,
    mint::authority = authority,
    mint::decimals = 0,
    payer = payer
    )]
    pub collection: Account<'info, Mint>,
    #[account(mut,
    seeds = [
    PREFIX.as_bytes(),
    metadata_program.key().as_ref(),
    collection.key().as_ref()
    ], bump,
    seeds::program = metadata_program.key()
    )]
    /// CHECK: uninitialized metadata
    pub metadata: UncheckedAccount<'info>,
    #[account(mut)]
    pub payer: Signer<'info>,
    // token program
    pub token_program: Program<'info, Token>,
    // metadata program
    pub metadata_program: Program<'info, MetadataProgram>,
    // system program
    pub system_program: Program<'info, System>,
    // rent program
    pub rent: Sysvar<'info, Rent>,
}

#[derive(Clone)]
pub struct MetadataProgram;

impl anchor_lang::Id for MetadataProgram {
    fn id() -> Pubkey {
        mpl_token_metadata::ID
    }
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
