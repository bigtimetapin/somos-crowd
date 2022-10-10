module Model.HandleForm exposing (HandleForm(..))

import Model.Handle exposing (Handle)


type HandleForm
    = Start
    | TypingHandle String
    | ConfirmHandle Handle
