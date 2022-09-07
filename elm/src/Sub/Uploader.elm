port module Sub.Uploader exposing (..)

-- senders


port connectAsUploader : () -> Cmd msg



-- listeners


port connectAsUploaderSuccess : (Json -> msg) -> Sub msg


type alias Json =
    String
