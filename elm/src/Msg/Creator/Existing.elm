module Msg.Creator.Existing exposing (Existing(..), toString)

import Model.HandleForm exposing (HandleForm(..))


type Existing
    = HandleForm HandleForm
    -- | CreateNewCollection TODO


-- create new collection
-- | InitializeCollection Wallet AlmostCollection


toString : Existing -> String
toString existing =
    case existing of
        HandleForm handleForm ->
            case handleForm of
                ConfirmHandle _ ->
                    "existing-creator-confirm-handle"

                _ ->
                    "no-op"



-- Existing.InitializeCollection _ _ ->
-- "creator-initialize-collection"
