module Model.AlmostCollection exposing (AlmostCollection, encode)

import Json.Encode as Encode

type alias AlmostCollection =
    { name : String
    , symbol : String
    }

encode : AlmostCollection -> String
encode almostCollection =
    let
        encoder =
            Encode.object
                [ ( "name", Encode.string almostCollection.name )
                , ( "symbol", Encode.string almostCollection.symbol )
                ]
    in
    Encode.encode 0 encoder
