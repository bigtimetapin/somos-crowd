module Model.HandleForm exposing (HandleForm(..))

import Model.Handle exposing (Handle)
import Model.Wallet exposing (Wallet)

type HandleForm
    = Start Wallet
    | TypingHandle Wallet String
    | ConfirmHandle Wallet Handle
