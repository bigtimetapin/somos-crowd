use anchor_lang::Key;
use anchor_lang::prelude::{Context, Result};
use crate::{InitNewCreator, pda};
use crate::error::CustomErrors;
use crate::pda::creator::Highlighted;

pub fn ix(
    ctx: Context<InitNewCreator>,
    seed: String,
) -> Result<()> {
    let creator = &mut ctx.accounts.creator;
    // authority
    creator.authority = ctx.accounts.payer.key();
    // handle
    validate_handle(&seed)?;
    creator.handle = seed;
    // collections
    creator.num_collections = 0;
    creator.highlighted = Highlighted { collections: [0; 10] };
    Ok(())
}

fn validate_handle(handle: &String) -> Result<()> {
    match handle.len() > pda::creator::MAX_HANDLE_LENGTH {
        true => {
            Ok(())
        }
        false => {
            Err(CustomErrors::HandleTooLong.into())
        }
    }
}
