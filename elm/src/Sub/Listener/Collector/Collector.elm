module Sub.Listener.Collector.Collector exposing (ToCollector(..), fromString)


type ToCollector
    = HandleInvalid
    | HandleDoesNotExist
    | HandleFound


fromString : String -> Maybe ToCollector
fromString string =
    case string of
        "collector-handle-invalid" ->
            Just HandleInvalid

        "collector-handle-dne" ->
            Just HandleDoesNotExist

        "collector-handle-found" ->
            Just HandleFound

        _ ->
            Nothing
