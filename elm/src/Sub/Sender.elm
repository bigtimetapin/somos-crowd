port module Sub.Sender exposing (sender)


port sender : Json -> Cmd msg


type alias Json =
    String
