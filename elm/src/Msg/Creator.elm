module Msg.Creator exposing (FromCreator(..), toString)

import Model.AlmostCollection exposing (AlmostCollection)
import Model.Handle exposing (Handle)
import Model.Wallet exposing (Wallet)


type FromCreator
    = AuthorizeHandle Handle
      -- init
    | InitializeCollection Wallet AlmostCollection


toString : FromCreator -> String
toString fromCreator =
    case fromCreator of
        AuthorizeHandle _ ->
            "creator-authorize-handle"

        InitializeCollection _ _ ->
            "creator-initialize-collection"
