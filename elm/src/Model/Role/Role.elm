module Model.Role.Role exposing (Creator(..), Role(..), decode0, encode, encode0)

import Json.Decode as Decode
import Json.Encode as Encode
import Msg.Creator as CreatorMsg


type Role
    = Create Creator


type Creator
    = FromCreator CreatorMsg.FromCreator
    | ToCreator ToCreatorMsg


type ToCreatorMsg
    = ConnectAsCreatorSuccess


type alias WithMore =
    { role : Role
    , more : Json
    }


encode : Role -> Json -> Json
encode role more =
    let
        encoder =
            Encode.object
                [ ( "role", Encode.string <| toString role )
                , ( "more", Encode.string more )
                ]
    in
    Encode.encode 0 encoder


encode0 : Role -> Json
encode0 role =
    let
        encoder =
            Encode.object
                [ ( "role", Encode.string <| toString role )
                ]
    in
    Encode.encode 0 encoder


decode0 : String -> Result String (Maybe Role)
decode0 string =
    let
        decoder : Decode.Decoder (Maybe Role)
        decoder =
            Decode.field "role" <| Decode.map fromString Decode.string
    in
    case Decode.decodeString decoder string of
        Ok value ->
            Ok value

        Err error ->
            Err <| Decode.errorToString error


toString : Role -> String
toString role =
    case role of
        Create creator ->
            case creator of
                FromCreator fromCreator ->
                    CreatorMsg.toString fromCreator

                ToCreator toCreatorMsg ->
                    case toCreatorMsg of
                        ConnectAsCreatorSuccess ->
                            "creator-connect-success"


fromString : String -> Maybe Role
fromString string =
    case string of
        "creator-connect" ->
            Just <| Create ConnectAsCreator

        _ ->
            Nothing


type alias Json =
    String
