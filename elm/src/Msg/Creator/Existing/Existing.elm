module Msg.Creator.Existing.Existing exposing (Existing(..), toString)

import Model.AlmostCollection exposing (AlmostCollection)
import Model.Handle exposing (Handle)
import Model.StringForm exposing (StringForm(..))
import Model.Wallet exposing (Wallet)
import Msg.Creator.Existing.NewCollectionForm exposing (NewCollectionForm)


type Existing
    = StartHandleForm
    | HandleForm StringForm
      -- new collection
    | StartCreatingNewCollection Wallet Handle
    | NewCollectionForm Wallet Handle NewCollectionForm
    | CreateNewCollection Wallet AlmostCollection


toString : Existing -> String
toString existing =
    case existing of
        HandleForm handleForm ->
            case handleForm of
                Confirm _ ->
                    "existing-creator-confirm-handle"

                _ ->
                    "no-op"

        CreateNewCollection _ _ ->
            "creator-create-new-collection"

        _ ->
            "no-op"
