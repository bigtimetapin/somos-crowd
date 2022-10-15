module View.Generic.Collection exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class)
import Model.Collection exposing (Collection)
import Msg.Msg exposing (Msg)


view : Collection -> Html Msg
view collection =
    Html.div
        [ class "has-border-2 px-2 py-2"
        ]
        [ Html.div
            [ class "has-border-2 px-2 py-2 mb-2"
            ]
            [ Html.text collection.name
            ]
        , Html.div
            [ class "has-border-2 px-2 py-2 mb-2"
            ]
            [ Html.text collection.symbol
            ]
        , Html.div
            [ class "has-border-2 px-2 py-2 mb-2"
            ]
            [ Html.text <| String.fromInt collection.index
            ]
        ]
