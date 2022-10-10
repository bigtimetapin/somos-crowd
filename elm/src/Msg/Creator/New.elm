module Msg.Creator.New exposing (New(..), toString)

import Model.HandleForm exposing (HandleForm(..))


type New
    = HandleForm HandleForm


toString : New -> String
toString new =
    case new of
        HandleForm handleForm ->
            case handleForm of
                ConfirmHandle _ ->
                    "new-creator-confirm-handle"

                _ ->
                    "no-op"
