module View.Generic.Collection.Collector.Collector exposing (view, viewMany)

import Html exposing (Html)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Model.Collection exposing (Collection)
import Model.Handle exposing (Handle)
import Msg.Collector exposing (FromCollector(..))
import Msg.Msg exposing (Msg(..))
import View.Generic.Collection.Collection


view : Handle -> Collection -> Html Msg
view handle collection =
    View.Generic.Collection.Collection.view handle collection


viewMany : Handle -> List Collection -> Html Msg
viewMany handle collections =
    View.Generic.Collection.Collection.viewMany handle collections select


select : Handle -> Collection -> Html Msg
select handle collection =
    Html.div
        []
        [ Html.button
            -- TODO; href
            [ class "is-button-1"
            , style "width" "100%"
            , onClick <| FromCollector <| SelectCollection handle collection
            ]
            [ Html.text "Select"
            ]
        ]
