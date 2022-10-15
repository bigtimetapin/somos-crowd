module Msg.Creator.New exposing (New(..), toString)

import Model.HandleForm exposing (StringForm(..))


type New
    = HandleForm StringForm


toString : New -> String
toString new =
    case new of
        HandleForm handleForm ->
            case handleForm of
                Confirm _ ->
                    "new-creator-confirm-handle"

                _ ->
                    "no-op"
