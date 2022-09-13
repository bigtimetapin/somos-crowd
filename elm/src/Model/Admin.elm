module Model.Admin exposing (Admin(..))

import Model.Wallet exposing (Wallet)


type Admin
    = Top
    | WaitingForWallet
    | HasWallet Wallet
    | WaitingForInitializeTariff Wallet
    | InitializedTariff Wallet
