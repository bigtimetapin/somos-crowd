module Model.Role.Listener exposing (Listener(..), ToCreator(..), WithMore, decode0, decode1)

import Json.Decode as Decode


type Listener
    = Create ToCreator


type ToCreator
    = ConnectAsCreatorSuccess


type alias WithMore =
    { listener : Listener
    , more : Json
    }


decode0 : String -> Result String (Maybe Listener)
decode0 string =
    let
        decoder : Decode.Decoder (Maybe Listener)
        decoder =
            Decode.field "listener" <| Decode.map fromString Decode.string
    in
    case Decode.decodeString decoder string of
        Ok value ->
            Ok value

        Err error ->
            Err <| Decode.errorToString error


decode1 : String -> Result String Json
decode1 string =
    let
        decoder =
            Decode.field "more" Decode.string
    in
    case Decode.decodeString decoder string of
        Ok value ->
            Ok value

        Err error ->
            Err <| Decode.errorToString error


fromString : String -> Maybe Listener
fromString string =
    case string of
        "creator-connect-success" ->
            Just <| Create ConnectAsCreatorSuccess

        _ ->
            Nothing


type alias Json =
    String
