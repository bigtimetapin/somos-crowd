module Model.Role.Listener exposing (Listener(..), ToCreator(..), WithMore, decode0, decode1, decode2)

import Json.Decode as Decode
import Model.Model exposing (Model)
import Model.State as Model
import Msg.Msg exposing (Msg)


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


decode2 : Model -> Json -> (String -> Result String a) -> (a -> Model) -> ( Model, Cmd Msg )
decode2 model json moreDecoder update =
    case decode1 json of
        -- more found
        Ok moreJson ->
            -- decode
            case moreDecoder moreJson of
                Ok decoded ->
                    ( update decoded
                    , Cmd.none
                    )

                -- error from decoder
                Err string ->
                    ( { model | state = Model.Error string }
                    , Cmd.none
                    )

        -- error from decoder
        Err string ->
            ( { model | state = Model.Error string }
            , Cmd.none
            )


fromString : String -> Maybe Listener
fromString string =
    case string of
        "creator-connect-success" ->
            Just <| Create ConnectAsCreatorSuccess

        _ ->
            Nothing


type alias Json =
    String
