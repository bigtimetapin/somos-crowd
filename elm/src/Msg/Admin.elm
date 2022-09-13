module Msg.Admin exposing (FromAdmin(..), toString)

import Model.Wallet exposing (Wallet)


type FromAdmin
    = Connect
    | InitializeTariff Wallet


toString : FromAdmin -> String
toString admin =
    case admin of
        Connect ->
            "admin-connect"


        InitializeTariff _ ->
            "admin-initialize-tariff"
