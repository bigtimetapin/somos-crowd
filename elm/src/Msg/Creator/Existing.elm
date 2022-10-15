module Msg.Creator.Existing exposing (Existing(..), toString)

import Model.HandleForm exposing (StringForm(..))


type Existing
    = HandleForm StringForm



-- | CreateNewCollection TODO
-- create new collection
-- | InitializeCollection Wallet AlmostCollection


toString : Existing -> String
toString existing =
    case existing of
        HandleForm handleForm ->
            case handleForm of
                Confirm _ ->
                    "existing-creator-confirm-handle"

                _ ->
                    "no-op"



-- Existing.InitializeCollection _ _ ->
-- "creator-initialize-collection"
