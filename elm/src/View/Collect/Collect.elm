module View.Collect.Collect exposing (body)

import Html exposing (Html)
import Html.Attributes exposing (class, placeholder, type_)
import Html.Events exposing (onClick, onInput)
import Model.Collector exposing (Collector(..))
import Model.Handle as Handle
import Msg.Collector as CollectorMsg
import Msg.Msg exposing (Msg(..))
import View.Generic.Collection
import View.Generic.Wallet


body : Collector -> Html Msg
body collector =
    let
        html =
            case collector of
                TypingHandle string ->
                    let
                        select =
                            case string of
                                "" ->
                                    Html.div
                                        []
                                        []

                                _ ->
                                    Html.div
                                        []
                                        [ Html.button
                                            [ class "is-button-1"
                                            , onClick <|
                                                FromCollector <|
                                                    CollectorMsg.HandleForm <|
                                                        Handle.Confirm string
                                            ]
                                            [ Html.text <|
                                                String.concat
                                                    [ "search for collections from handle:"
                                                    , " "
                                                    , string
                                                    ]
                                            ]
                                        ]
                    in
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ header
                        , Html.div
                            [ class "field"
                            ]
                            [ Html.p
                                [ class "control has-icons-left"
                                ]
                                [ Html.input
                                    [ class "input"
                                    , type_ "text"
                                    , placeholder "Handle"
                                    , onInput <|
                                        \s ->
                                            FromCollector <|
                                                CollectorMsg.HandleForm <|
                                                    Handle.Typing s
                                    ]
                                    []
                                , Html.span
                                    [ class "icon is-left"
                                    ]
                                    [ Html.i
                                        [ class "fas fa-at"
                                        ]
                                        []
                                    ]
                                ]
                            ]
                        , select
                        ]

                WaitingForHandleConfirmation ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ header
                        , Html.div
                            [ class "is-loading"
                            ]
                            []
                        ]

                HandleInvalid string ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ header
                        , Html.div
                            [ class "has-border-2 px-2 py-2"
                            ]
                            [ Html.text <|
                                String.concat
                                    [ "input handle found to be invalid:"
                                    , " "
                                    , string
                                    ]
                            , Html.div
                                [ class "pt-1"
                                ]
                                [ Html.button
                                    [ class "is-button-1"
                                    , onClick <|
                                        FromCollector <|
                                            CollectorMsg.HandleForm <|
                                                Handle.Typing ""
                                    ]
                                    [ Html.text
                                        """try again
                                        """
                                    ]
                                ]
                            ]
                        ]

                HandleDoesNotExist string ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ header
                        , Html.div
                            [ class "has-border-2 px-2 py-2"
                            ]
                            [ Html.text <|
                                String.concat
                                    [ "input handle does-not-exist:"
                                    , " "
                                    , string
                                    ]
                            , Html.div
                                [ class "pt-1"
                                ]
                                [ Html.button
                                    [ class "is-button-1"
                                    , onClick <|
                                        FromCollector <|
                                            CollectorMsg.HandleForm <|
                                                Handle.Typing ""
                                    ]
                                    [ Html.text
                                        """try again
                                        """
                                    ]
                                ]
                            ]
                        ]

                SelectedCreator withCollections ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ header
                        , Html.div
                            []
                            [ Html.text <|
                                String.concat
                                    [ "creator:"
                                    , " "
                                    , withCollections.handle
                                    ]
                            ]
                        , Html.div
                            []
                            [ Html.text "collections ⬇️"
                            ]
                        , Html.div
                            []
                          <|
                            List.map
                                (\c -> View.Generic.Collection.view { selected = False } withCollections.handle c)
                                withCollections.collections
                        ]

                SelectedCollection handle collection ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ header
                        , Html.div
                            []
                            [ Html.text <|
                                String.concat
                                    [ "creator:"
                                    , " "
                                    , handle
                                    ]
                            ]
                        , Html.div
                            []
                            [ Html.text "collection selected ⬇️"
                            ]
                        , Html.div
                            []
                            [ View.Generic.Collection.view { selected = True } handle collection
                            ]
                        ]

                WaitingForPurchase ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ header
                        , Html.div
                            [ class "is-loading"
                            ]
                            []
                        ]

                PurchaseSuccess wallet handle collection ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ View.Generic.Wallet.view wallet
                        , header
                        , Html.div
                            []
                            [ Html.text <|
                                String.concat
                                    [ "creator:"
                                    , " "
                                    , handle
                                    ]
                            ]
                        , Html.div
                            []
                            [ Html.text "collection selected ⬇️"
                            ]
                        , Html.div
                            []
                            [ View.Generic.Collection.view { selected = True } handle collection
                            ]
                        ]
    in
    Html.div
        [ class "container"
        ]
        [ html
        ]


header : Html Msg
header =
    Html.div
        [ class "is-family-secondary mt-2 mb-5"
        ]
        [ Html.h2
            []
            [ Html.text "Collector Console"
            ]
        ]
