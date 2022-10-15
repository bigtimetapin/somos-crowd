module Model.Creator.Existing.WithCollections exposing (WithCollections, decode)

import Json.Decode as Decode
import Model.Collection as Collection exposing (Collection)
import Model.Handle exposing (Handle)
import Model.Wallet exposing (Wallet)
import Util.Decode as Util


type alias WithCollections =
    { handle : Handle
    , wallet : Wallet
    , collections : List Collection
    }


decode : String -> Result String WithCollections
decode string =
    let
        decoder : Decode.Decoder WithCollections
        decoder =
            Decode.map3 WithCollections
                (Decode.field "handle" Decode.string)
                (Decode.field "wallet" Decode.string)
                (Decode.field "collections" <| Decode.list Collection.decoder)
    in
    Util.decode string decoder identity
