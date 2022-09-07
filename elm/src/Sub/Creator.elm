port module Sub.Creator exposing (..)

-- senders


port connectAsCreator : () -> Cmd msg



-- listeners


port connectAsCreatorSuccess : (Json -> msg) -> Sub msg


type alias Json =
    String
