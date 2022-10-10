module Sub.Sender.Sender exposing (Sender(..), WithMore, encode, encode0)

import Json.Encode as Encode
import Msg.Admin as AdminMsg exposing (FromAdmin)
import Msg.Creator.Creator as CreatorMsg exposing (FromCreator)


type Sender
    = Create FromCreator
    | Administrate FromAdmin


type alias WithMore =
    { sender : Sender
    , more : Json
    }


encode : WithMore -> Json
encode withMore =
    let
        encoder =
            Encode.object
                [ ( "sender", Encode.string <| toString withMore.sender )
                , ( "more", Encode.string withMore.more )
                ]
    in
    Encode.encode 0 encoder


encode0 : Sender -> Json
encode0 role =
    let
        encoder =
            Encode.object
                [ ( "sender", Encode.string <| toString role )
                ]
    in
    Encode.encode 0 encoder


toString : Sender -> String
toString role =
    case role of
        Create fromCreator ->
            CreatorMsg.toString fromCreator

        Administrate fromAdmin ->
            AdminMsg.toString fromAdmin


type alias Json =
    String
