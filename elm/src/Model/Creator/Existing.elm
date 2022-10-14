module Model.Creator.Existing exposing (Existing(..), HandleFormStatus(..))

import Model.Handle exposing (Handle)
import Model.Wallet exposing (Wallet)


type Existing
    = Top
    | HandleForm HandleFormStatus
    | Authorized Wallet Handle


type HandleFormStatus
    = TypingHandle String
    | WaitingForHandleConfirmation
    | HandleInvalid String
    | HandleDoesNotExist String
    | UnAuthorized Wallet Handle
