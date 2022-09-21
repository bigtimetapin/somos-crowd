module Model.Creator exposing (Creator(..))

import Model.Collection exposing (Collection)
import Model.Wallet exposing (Wallet)


type Creator
    = Top
    | WaitingForWallet
    | HasWallet Wallet
    | WaitingForCollectionToInitialize Wallet
    | HasCollection Collection
