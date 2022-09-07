module Model.Uploader exposing (Uploader(..))

import Model.Wallet exposing (Wallet)


type Uploader
    = Top
    | WaitingForWallet
    | HasWallet Wallet
