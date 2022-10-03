module Model.Collection exposing (Collection, decode)

import Json.Decode as Decode
import Model.Wallet exposing (Wallet)
import Util.Decode as Util


type alias Collection =
    { wallet : Wallet -- current user; not in on-chain model
    , name : String
    , symbol : String
    }


decode : String -> Result String Collection
decode string =
    let
        decoder : Decode.Decoder Collection
        decoder =
            Decode.map3 Collection
                (Decode.field "wallet" Decode.string)
                (Decode.field "name" Decode.string)
                (Decode.field "symbol" Decode.string)
    in
    Util.decode string decoder (\a -> a)
