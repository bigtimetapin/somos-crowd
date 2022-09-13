port module Sub.Listener exposing (..)


port success : (Json -> msg) -> Sub msg


port error : (String -> msg) -> Sub msg


type alias Json =
    String
