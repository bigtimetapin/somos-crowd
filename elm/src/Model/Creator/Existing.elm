module Model.Creator.Existing exposing (Existing(..), HandleFormStatus(..))

import Model.Handle exposing (Handle)
import Model.Wallet exposing (Wallet)

type Existing
    = Top Wallet
    | HandleForm Wallet HandleFormStatus
    | Authorized Wallet Handle

type HandleFormStatus
    = TypingHandle String
    | HandleInvalid String
    | HandleDoesNotExist String
    | UnAuthorized Handle
