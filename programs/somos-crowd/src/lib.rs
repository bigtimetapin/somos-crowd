use anchor_lang::prelude::*;
use anchor_spl::associated_token::AssociatedToken;
use anchor_spl::token::{mint_to, Mint, MintTo, Token, TokenAccount};
use mpl_token_metadata::state::{PREFIX, EDITION};
use mpl_token_metadata::instruction::{create_metadata_accounts_v3, create_master_edition_v3};

declare_id!("HRLqhFshmXMXZmY1Fkz8jJTktMEkoxLssFDtydkW5xXa");

#[program]
pub mod somos_crowd {
    use mpl_token_metadata::state::CollectionDetails;
    use super::*;

    pub fn create_collection(
        ctx: Context<CreateCollection>,
        name: String,
        symbol: String,
        uri: String,
        size: u64,
    ) -> Result<()> {
        // unwrap authority bump
        let authority_bump = *ctx.bumps.get("authority").unwrap();
        // build signer seeds
        let seeds = &[
            "authority".as_bytes(), &ctx.accounts.collection.key().to_bytes(),
            &[authority_bump]
        ];
        let signer_seeds = &[&seeds[..]];
        // build metadata instruction
        let ix_metadata = create_metadata_accounts_v3(
            ctx.accounts.metadata_program.key(),
            ctx.accounts.metadata.key(),
            ctx.accounts.collection.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.payer.key(),
            ctx.accounts.authority.key(),
            name,
            symbol,
            uri,
            None,
            500,
            false,
            false,
            None,
            None,
            Some(CollectionDetails::V1 { size }),
        );
        // build ata master-edition instruction
        let ata_cpi_accounts = MintTo {
            mint: ctx.accounts.collection.to_account_info(),
            to: ctx.accounts.master_edition_ata.to_account_info(),
            authority: ctx.accounts.authority.to_account_info(),
        };
        let ata_cpi_context = CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            ata_cpi_accounts,
        );
        // build mark master-edition instruction
        let ix_mark_master_edition = create_master_edition_v3(
            ctx.accounts.metadata_program.key(),
            ctx.accounts.master_edition.key(),
            ctx.accounts.collection.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.metadata.key(),
            ctx.accounts.payer.key(),
            None,
        );
        // invoke create metadata
        let invoked0 = anchor_lang::solana_program::program::invoke_signed(
            &ix_metadata,
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
        );
        match invoked0 {
            Ok(_) => {
                // mint ata
                match mint_to(
                    ata_cpi_context.with_signer(
                        signer_seeds
                    ),
                    1,
                ) {
                    Ok(_) => {
                        // invoke create master-edition
                        anchor_lang::solana_program::program::invoke_signed(
                            &ix_mark_master_edition,
                            &[
                                ctx.accounts.master_edition.to_account_info(),
                                ctx.accounts.collection.to_account_info(),
                                ctx.accounts.authority.to_account_info(),
                                ctx.accounts.authority.to_account_info(),
                                ctx.accounts.metadata.to_account_info(),
                                ctx.accounts.payer.to_account_info(),
                                ctx.accounts.system_program.to_account_info(),
                                ctx.accounts.rent.to_account_info()
                            ],
                            signer_seeds,
                        ).map_err(Into::into)
                    }
                    err @ Err(_) => {
                        err
                    }
                }
            }
            Err(error) => {
                Err(Error::from(error))
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// Impl ////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#[derive(Accounts)]
pub struct CreateCollection<'info> {
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
    #[account(mut,
    seeds = [
    PREFIX.as_bytes(),
    metadata_program.key().as_ref(),
    collection.key().as_ref(),
    EDITION.as_bytes()
    ], bump,
    seeds::program = metadata_program.key()
    )]
    /// CHECK: uninitialized master-edition
    pub master_edition: UncheckedAccount<'info>,
    #[account(init,
    associated_token::mint = collection,
    associated_token::authority = authority,
    payer = payer
    )]
    pub master_edition_ata: Account<'info, TokenAccount>,
    #[account(mut)]
    pub payer: Signer<'info>,
    // token program
    pub token_program: Program<'info, Token>,
    // associated token program
    pub associated_token_program: Program<'info, AssociatedToken>,
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
