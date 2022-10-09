module Model.Creator.New exposing (New(..))

import Model.Wallet exposing (Wallet)

type New
    = Top Wallet
    | TypingHandle Wallet String
    | WaitingForHandleConfirmation Wallet
    | HandleInvalid Wallet String
    | HandleAlreadyExists Wallet String
