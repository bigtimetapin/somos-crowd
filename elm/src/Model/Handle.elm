module Model.Handle exposing (Handle, WithWallet, decode, decodeWithWallet, encode)

import Json.Decode as Decode
import Json.Encode as Encode
import Model.Wallet exposing (Wallet)
import Util.Decode as Util


type alias Handle =
    String


encode : Handle -> String
encode handle =
    let
        encoder =
            Encode.object
                [ ( "handle", Encode.string handle )
                ]
    in
    Encode.encode 0 encoder


type alias WithWallet =
    { handle : String
    , wallet : Wallet
    }


decode : String -> Result String Handle
decode string =
    let
        decoder : Decode.Decoder Handle
        decoder =
            Decode.string
    in
    Util.decode string decoder identity


decodeWithWallet : String -> Result String WithWallet
decodeWithWallet string =
    let
        decoder : Decode.Decoder WithWallet
        decoder =
            Decode.map2 WithWallet
                (Decode.field "handle" Decode.string)
                (Decode.field "wallet" Decode.string)
    in
    Util.decode string decoder identity
