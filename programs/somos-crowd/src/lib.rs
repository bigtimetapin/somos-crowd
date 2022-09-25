use anchor_lang::prelude::*;
use anchor_spl::associated_token::AssociatedToken;
use anchor_spl::token::{mint_to, Mint, MintTo, Token, TokenAccount};
use mpl_token_metadata::state::{
    PREFIX, EDITION, EDITION_MARKER_BIT_SIZE, CollectionDetails, Creator,
};
use mpl_token_metadata::instruction::{
    create_metadata_accounts_v3, create_master_edition_v3, sign_metadata,
    mint_new_edition_from_master_edition_via_token, set_and_verify_sized_collection_item,
};

declare_id!("HRLqhFshmXMXZmY1Fkz8jJTktMEkoxLssFDtydkW5xXa");

#[program]
pub mod somos_crowd {
    use super::*;

    pub fn create_nft(
        ctx: Context<CreateNFT>,
        name: String,
        symbol: String,
        uri: String,
        size: u64,
    ) -> Result<()> {
        // unwrap authority bump
        let authority_bump = *ctx.bumps.get("authority").unwrap();
        // build signer seeds
        let seeds = &[
            "authority".as_bytes(), &ctx.accounts.mint.key().to_bytes(),
            &[authority_bump]
        ];
        let signer_seeds = &[&seeds[..]];
        // build metadata instruction
        let ix_metadata = create_metadata_accounts_v3(
            ctx.accounts.metadata_program.key(),
            ctx.accounts.metadata.key(),
            ctx.accounts.mint.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.payer.key(),
            ctx.accounts.authority.key(),
            name,
            symbol,
            uri,
            Some(vec![
                Creator {
                    address: ctx.accounts.payer.key(),
                    verified: false,
                    share: 100,
                }
            ]),
            500,
            false,
            false,
            None,
            None,
            None,
        );
        // build collection metadata instruction for collection
        let ix_collection_metadata = create_metadata_accounts_v3(
            ctx.accounts.metadata_program.key(),
            ctx.accounts.collection_metadata.key(),
            ctx.accounts.collection.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.payer.key(),
            ctx.accounts.authority.key(),
            String::from("Collection"),
            String::from("COL"),
            String::from(""),
            Some(vec![
                Creator {
                    address: ctx.accounts.payer.key(),
                    verified: false,
                    share: 100,
                }
            ]),
            0,
            false,
            false,
            None,
            None,
            Some(CollectionDetails::V1 { size }),
        );
        // build sign metadata instruction
        let ix_sign_metadata = sign_metadata(
            ctx.accounts.metadata_program.key(),
            ctx.accounts.metadata.key(),
            ctx.accounts.payer.key(),
        );
        // build sign collection metadata instruction
        let ix_sign_collection_metadata = sign_metadata(
            ctx.accounts.metadata_program.key(),
            ctx.accounts.collection_metadata.key(),
            ctx.accounts.payer.key(),
        );
        // build ata master-edition instruction
        let ata_cpi_accounts = MintTo {
            mint: ctx.accounts.mint.to_account_info(),
            to: ctx.accounts.master_edition_ata.to_account_info(),
            authority: ctx.accounts.authority.to_account_info(),
        };
        let ata_cpi_context = CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            ata_cpi_accounts,
        );
        // build ata collection master-edition instruction
        let collection_ata_cpi_accounts = MintTo {
            mint: ctx.accounts.collection.to_account_info(),
            to: ctx.accounts.collection_master_edition_ata.to_account_info(),
            authority: ctx.accounts.authority.to_account_info(),
        };
        let collection_ata_cpi_context = CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            collection_ata_cpi_accounts,
        );
        // build create master-edition instruction
        let ix_create_master_edition = create_master_edition_v3(
            ctx.accounts.metadata_program.key(),
            ctx.accounts.master_edition.key(),
            ctx.accounts.mint.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.metadata.key(),
            ctx.accounts.payer.key(),
            Some(0), // TODO
        );
        // build create collection master-edition instruction
        let ix_create_collection_master_edition = create_master_edition_v3(
            ctx.accounts.metadata_program.key(),
            ctx.accounts.collection_master_edition.key(),
            ctx.accounts.collection.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.collection_metadata.key(),
            ctx.accounts.payer.key(),
            Some(0),
        );
        // invoke create metadata
        anchor_lang::solana_program::program::invoke_signed(
            &ix_metadata,
            &[
                ctx.accounts.metadata.to_account_info(),
                ctx.accounts.mint.to_account_info(),
                ctx.accounts.authority.to_account_info(),
                ctx.accounts.payer.to_account_info(),
                ctx.accounts.authority.to_account_info(),
                ctx.accounts.system_program.to_account_info(),
                ctx.accounts.rent.to_account_info()
            ],
            signer_seeds,
        )?;
        // invoke create collection metadata
        anchor_lang::solana_program::program::invoke_signed(
            &ix_collection_metadata,
            &[
                ctx.accounts.collection_metadata.to_account_info(),
                ctx.accounts.collection.to_account_info(),
                ctx.accounts.authority.to_account_info(),
                ctx.accounts.payer.to_account_info(),
                ctx.accounts.authority.to_account_info(),
                ctx.accounts.system_program.to_account_info(),
                ctx.accounts.rent.to_account_info()
            ],
            signer_seeds,
        )?;
        // invoke sign metadata
        anchor_lang::solana_program::program::invoke(
            &ix_sign_metadata,
            &[
                ctx.accounts.metadata.to_account_info(),
                ctx.accounts.payer.to_account_info()
            ],
        )?;
        // invoke sign collection metadata
        anchor_lang::solana_program::program::invoke(
            &ix_sign_collection_metadata,
            &[
                ctx.accounts.collection_metadata.to_account_info(),
                ctx.accounts.payer.to_account_info()
            ],
        )?;
        // invoke ata master-edition
        mint_to(
            ata_cpi_context.with_signer(
                signer_seeds
            ),
            1,
        )?;
        // invoke ata collection master-edition
        mint_to(
            collection_ata_cpi_context.with_signer(
                signer_seeds
            ),
            1
        )?;
        // invoke create master-edition
        anchor_lang::solana_program::program::invoke_signed(
            &ix_create_master_edition,
            &[
                ctx.accounts.master_edition.to_account_info(),
                ctx.accounts.mint.to_account_info(),
                ctx.accounts.authority.to_account_info(),
                ctx.accounts.authority.to_account_info(),
                ctx.accounts.metadata.to_account_info(),
                ctx.accounts.payer.to_account_info(),
                ctx.accounts.system_program.to_account_info(),
                ctx.accounts.rent.to_account_info()
            ],
            signer_seeds,
        )?;
        // invoke create collection master edition
        anchor_lang::solana_program::program::invoke_signed(
            &ix_create_collection_master_edition,
            &[
                ctx.accounts.collection_master_edition.to_account_info(),
                ctx.accounts.collection.to_account_info(),
                ctx.accounts.authority.to_account_info(),
                ctx.accounts.authority.to_account_info(),
                ctx.accounts.collection_metadata.to_account_info(),
                ctx.accounts.payer.to_account_info(),
                ctx.accounts.system_program.to_account_info(),
                ctx.accounts.rent.to_account_info()
            ],
            signer_seeds,
        )?;
        // init authority data
        let authority = &mut ctx.accounts.authority;
        authority.mint = ctx.accounts.mint.key();
        authority.collection = ctx.accounts.collection.key();
        authority.num_minted = 0;
        Ok(())
    }

    pub fn mint_new_copy(ctx: Context<MintNewCopy>, edition_number: u64) -> Result<()> {
        // unwrap authority bump
        let authority_bump = *ctx.bumps.get("authority").unwrap();
        // build signer seeds
        let seeds = &[
            "authority".as_bytes(), &ctx.accounts.mint.key().to_bytes(),
            &[authority_bump]
        ];
        let signer_seeds = &[&seeds[..]];
        // build ata new-edition instruction
        let ata_cpi_accounts = MintTo {
            mint: ctx.accounts.new_mint.to_account_info(),
            to: ctx.accounts.new_edition_ata.to_account_info(),
            authority: ctx.accounts.authority.to_account_info(),
        };
        let ata_cpi_context = CpiContext::new(
            ctx.accounts.token_program.to_account_info(),
            ata_cpi_accounts,
        );
        // build new-edition instruction
        let ix_new_edition = mint_new_edition_from_master_edition_via_token(
            ctx.accounts.metadata_program.key(),
            ctx.accounts.new_metadata.key(),
            ctx.accounts.new_edition.key(),
            ctx.accounts.master_edition.key(),
            ctx.accounts.new_mint.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.payer.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.master_edition_ata.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.metadata.key(),
            ctx.accounts.mint.key(),
            edition_number,
        );
        // build set-collection instruction
        let ix_set_collection = set_and_verify_sized_collection_item(
            ctx.accounts.metadata_program.key(),
            ctx.accounts.new_metadata.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.payer.key(),
            ctx.accounts.authority.key(),
            ctx.accounts.collection.key(),
            ctx.accounts.collection_metadata.key(),
            ctx.accounts.master_edition.key(),
            None,
        );
        // invoke mint-to ata new-edition
        mint_to(
            ata_cpi_context.with_signer(
                signer_seeds
            ),
            1,
        )?;
        // invoke new edition
        anchor_lang::solana_program::program::invoke_signed(
            &ix_new_edition,
            &[
                ctx.accounts.new_metadata.to_account_info(),
                ctx.accounts.new_edition.to_account_info(),
                ctx.accounts.master_edition.to_account_info(),
                ctx.accounts.new_mint.to_account_info(),
                ctx.accounts.new_edition_mark.to_account_info(),
                ctx.accounts.authority.to_account_info(),
                ctx.accounts.payer.to_account_info(),
                ctx.accounts.authority.to_account_info(),
                ctx.accounts.master_edition_ata.to_account_info(),
                ctx.accounts.authority.to_account_info(),
                ctx.accounts.metadata.to_account_info(),
                ctx.accounts.system_program.to_account_info(),
                ctx.accounts.rent.to_account_info(),
            ],
            signer_seeds,
        )?;
        // invoke set collection
        anchor_lang::solana_program::program::invoke_signed(
            &ix_set_collection,
            &[
                ctx.accounts.new_metadata.to_account_info(),
                ctx.accounts.authority.to_account_info(),
                ctx.accounts.payer.to_account_info(),
                ctx.accounts.authority.to_account_info(),
                ctx.accounts.mint.to_account_info(),
                ctx.accounts.metadata.to_account_info(),
                ctx.accounts.master_edition.to_account_info()
            ],
            signer_seeds,
        ).map_err(Into::into)
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// Impl ////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#[derive(Accounts)]
pub struct CreateNFT<'info> {
    #[account(init,
    seeds = [b"authority", mint.key().as_ref()], bump,
    payer = payer,
    space = Authority::SPACE
    )]
    pub authority: Box<Account<'info, Authority>>,
    #[account(init,
    mint::authority = authority,
    mint::decimals = 0,
    payer = payer
    )]
    pub mint: Account<'info, Mint>,
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
    mint.key().as_ref()
    ], bump,
    seeds::program = metadata_program.key()
    )]
    /// CHECK: uninitialized metadata
    pub metadata: UncheckedAccount<'info>,
    #[account(mut,
    seeds = [
    PREFIX.as_bytes(),
    metadata_program.key().as_ref(),
    collection.key().as_ref()
    ], bump,
    seeds::program = metadata_program.key()
    )]
    /// CHECK: uninitialized metadata
    pub collection_metadata: UncheckedAccount<'info>,
    #[account(mut,
    seeds = [
    PREFIX.as_bytes(),
    metadata_program.key().as_ref(),
    mint.key().as_ref(),
    EDITION.as_bytes()
    ], bump,
    seeds::program = metadata_program.key()
    )]
    /// CHECK: uninitialized master-edition
    pub master_edition: UncheckedAccount<'info>,
    #[account(mut,
    seeds = [
    PREFIX.as_bytes(),
    metadata_program.key().as_ref(),
    collection.key().as_ref(),
    EDITION.as_bytes()
    ], bump,
    seeds::program = metadata_program.key()
    )]
    /// CHECK: uninitialized collection master-edition
    pub collection_master_edition: UncheckedAccount<'info>,
    #[account(init,
    associated_token::mint = mint,
    associated_token::authority = authority,
    payer = payer
    )]
    pub master_edition_ata: Box<Account<'info, TokenAccount>>,
    #[account(init,
    associated_token::mint = collection,
    associated_token::authority = authority,
    payer = payer
    )]
    pub collection_master_edition_ata: Box<Account<'info, TokenAccount>>,
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

#[derive(Accounts)]
#[instruction(edition_number: u64)]
pub struct MintNewCopy<'info> {
    #[account(mut,
    seeds = [b"authority", mint.key().as_ref()], bump,
    )]
    pub authority: Box<Account<'info, Authority>>,
    #[account(mut,
    address = authority.mint,
    owner = token_program.key()
    )]
    pub mint: Account<'info, Mint>,
    #[account(mut,
    address = authority.collection,
    owner = token_program.key()
    )]
    pub collection: Account<'info, Mint>,
    // TODO: check if mut needed
    #[account(mut,
    seeds = [
    PREFIX.as_bytes(),
    metadata_program.key().as_ref(),
    mint.key().as_ref()
    ], bump,
    seeds::program = metadata_program.key()
    )]
    /// CHECK: initialized metadata
    pub metadata: UncheckedAccount<'info>,
    // TODO: check if mut needed
    #[account(mut,
    seeds = [
    PREFIX.as_bytes(),
    metadata_program.key().as_ref(),
    collection.key().as_ref()
    ], bump,
    seeds::program = metadata_program.key()
    )]
    /// CHECK: initialized metadata
    pub collection_metadata: UncheckedAccount<'info>,
    #[account(mut,
    seeds = [
    PREFIX.as_bytes(),
    metadata_program.key().as_ref(),
    mint.key().as_ref(),
    EDITION.as_bytes()
    ], bump,
    seeds::program = metadata_program.key()
    )]
    /// CHECK: master-edition
    pub master_edition: UncheckedAccount<'info>,
    // TODO: check if mut needed
    #[account(mut,
    associated_token::mint = mint,
    associated_token::authority = authority
    )]
    pub master_edition_ata: Box<Account<'info, TokenAccount>>,
    // TODO: check if mut needed
    #[account(init,
    mint::authority = authority,
    mint::decimals = 0,
    payer = payer
    )]
    pub new_mint: Box<Account<'info, Mint>>,
    #[account(mut,
    seeds = [
    PREFIX.as_bytes(),
    metadata_program.key().as_ref(),
    new_mint.key().as_ref()
    ], bump,
    seeds::program = metadata_program.key()
    )]
    /// CHECK: uninitialized new-metadata
    pub new_metadata: UncheckedAccount<'info>,
    #[account(mut,
    seeds = [
    PREFIX.as_bytes(),
    metadata_program.key().as_ref(),
    new_mint.key().as_ref(),
    EDITION.as_bytes()
    ], bump,
    seeds::program = metadata_program.key()
    )]
    /// CHECK: uninitialized new-edition
    pub new_edition: UncheckedAccount<'info>,
    #[account(mut,
    seeds = [
    PREFIX.as_bytes(),
    metadata_program.key().as_ref(),
    mint.key().as_ref(),
    EDITION.as_bytes(),
    edition_number.checked_div(EDITION_MARKER_BIT_SIZE).unwrap().to_string().as_bytes()
    ], bump,
    seeds::program = metadata_program.key()
    )]
    /// CHECK: uninitialized new-edition-mark
    pub new_edition_mark: UncheckedAccount<'info>,
    #[account(init,
    associated_token::mint = new_mint,
    associated_token::authority = payer,
    payer = payer
    )]
    pub new_edition_ata: Box<Account<'info, TokenAccount>>,
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
    pub mint: Pubkey,
    pub collection: Pubkey,
    pub num_minted: u64,
}

impl Authority {
    const SPACE: usize = 8 + 32 + 32 +  8;
}

#[error_code]
pub enum CustomErrors {
    #[msg("decentralized assets should be immutable.")]
    ImmutableAssets,
}
