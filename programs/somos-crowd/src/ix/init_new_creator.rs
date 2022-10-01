use anchor_lang::Key;
use anchor_lang::prelude::{Context, Result};
use crate::{InitNewCreator, pda};
use crate::error::CustomErrors;

pub fn ix(
    ctx: Context<InitNewCreator>,
    seed: String,
) -> Result<()> {
    let creator = &mut ctx.accounts.creator;
    creator.authority = ctx.accounts.payer.key();
    validate_handle(&seed)?;
    creator.handle = seed;
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
