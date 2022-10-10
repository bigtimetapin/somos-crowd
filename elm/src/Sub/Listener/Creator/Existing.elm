module Sub.Listener.Creator.Existing exposing (Existing(..), HandleFormStatus(..), fromString)


type Existing
    = HandleForm HandleFormStatus


type HandleFormStatus
    = Invalid
    | DoesNotExist
    | UnAuthorized
    | Authorized


fromString : String -> Maybe Existing
fromString string =
    case string of
        "existing-creator-handle-invalid" ->
            Just <| HandleForm Invalid

        "creator-handle-dne" ->
            Just <| HandleForm DoesNotExist

        "creator-handle-authorized" ->
            Just <| HandleForm Authorized

        "creator-handle-unauthorized" ->
            Just <| HandleForm UnAuthorized

        _ ->
            Nothing
