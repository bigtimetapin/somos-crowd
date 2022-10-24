module View.Generic.Collection exposing (view)

import Html exposing (Html)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Model.Collection exposing (Collection)
import Model.Handle exposing (Handle)
import Msg.Collector exposing (FromCollector(..))
import Msg.Msg exposing (Msg(..))


view : Args -> Handle -> Collection -> Html Msg
view args handle collection =
    let
        select =
            case args.selected of
                True ->
                    Html.div
                        []
                        []

                False ->
                    Html.div
                        []
                        [ Html.button
                            [ class "is-button-1"
                            , style "width" "100%"
                            , onClick <| FromCollector <| SelectCollection handle collection
                            ]
                            [ Html.text "Select"
                            ]
                        ]
    in
    Html.div
        [ class "has-border-2 px-2 py-2"
        ]
        [ select
        , Html.div
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


type alias Args =
    { selected : Bool
    }
