module Msg.Creator.New.New exposing (New(..), toString)

import Model.StringForm exposing (StringForm(..))


type New
    = StartHandleForm
    | HandleForm StringForm


toString : New -> String
toString new =
    case new of
        HandleForm handleForm ->
            case handleForm of
                Confirm _ ->
                    "new-creator-confirm-handle"

                _ ->
                    "no-op"

        _ ->
            "no-op"
