module Model.Creator exposing (Creator(..), MaybeHandle(..))

import Model.Collection exposing (Collection)
import Model.Handle as Handle exposing (Handle)
import Model.Wallet exposing (Wallet)


type Creator
    = Top
    | TypingHandle String
    | MaybeHasHandle MaybeHandle
    | WaitingForCollectionToInitialize Wallet
    | HasCollection Collection


type MaybeHandle
    = NeedsAuthorization Handle
    | WaitingForAuthorization
    | UnAuthorized Handle.WithWallet
    | Authorized Handle.WithWallet
