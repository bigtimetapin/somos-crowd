module Msg.Creator exposing (FromCreator(..), toString)


import Model.AlmostCollection exposing (AlmostCollection)
import Model.Wallet exposing (Wallet)

type
    FromCreator
    -- connect
    = Connect
    -- init
    | InitializeCollection Wallet AlmostCollection


toString : FromCreator -> String
toString fromCreator =
    case fromCreator of
        Connect ->
            "creator-connect"

        InitializeCollection _ _ ->
            "creator-initialize-collection"
