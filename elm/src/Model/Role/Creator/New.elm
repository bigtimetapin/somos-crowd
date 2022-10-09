module Model.Role.Creator.New exposing (New(..), fromString)

type New
    = HandleInvalid
    | HandleAlreadyExists
    | NewHandleSuccess


fromString : String -> Maybe New
fromString string =
    case string of
        "new-creator-invalid-handle" ->
            Just HandleInvalid

        "creator-handle-already-exists" ->
            Just HandleAlreadyExists

        "creator-new-handle-success" ->
            Just NewHandleSuccess

        _ ->
            Nothing
