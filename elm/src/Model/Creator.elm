module Model.Creator exposing (Creator(..))

import Model.Wallet exposing (Wallet)


type Creator
    = Top
    | WaitingForWallet
    | HasWallet Wallet
