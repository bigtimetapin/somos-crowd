module View.Collect.Collect exposing (body)

import Html exposing (Html)
import Html.Attributes exposing (class, placeholder, type_)
import Html.Events exposing (onClick, onInput)
import Model.Collector.Collector exposing (Collector(..))
import Model.Handle as Handle
import Msg.Collector as CollectorMsg
import Msg.Msg exposing (Msg(..))
import View.Generic.Collection.Collector.Collector
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
                        [ class "has-text-centered"
                        ]
                        [ Html.div
                            [ class "is-text-container-1 is-size-1 mb-2"
                            ]
                            [ Html.text "Sell your work."
                            ]
                        , Html.div
                            [ class "is-text-container-1 is-size-1 mb-5"
                            ]
                            [ Html.p
                                []
                                [ Html.text <|
                                    String.concat
                                        [ "Unlock and"
                                        , " "
                                        ]
                                , Html.strong
                                    [ class "is-family-secondary is-italic"
                                    ]
                                    [ Html.text "own"
                                    ]
                                , Html.text <|
                                    String.concat
                                        [ " "
                                        , "exclusive content."
                                        ]
                                ]
                            ]
                        , Html.div
                            []
                            [ Html.input
                                [ class "input is-size-3"
                                , type_ "text"
                                , placeholder "🔍 Find Creators"
                                , onInput <|
                                    \s ->
                                        FromCollector <|
                                            CollectorMsg.HandleForm <|
                                                Handle.Typing s
                                ]
                                []
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
                        , View.Generic.Collection.Collector.Collector.viewMany
                            withCollections.handle
                            withCollections.collections
                        ]

                SelectedCollection withCollection ->
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
                                    , withCollection.handle
                                    ]
                            ]
                        , Html.div
                            []
                            [ Html.text "collection selected ⬇️"
                            ]
                        , View.Generic.Collection.Collector.Collector.view
                            withCollection.handle
                            withCollection.collection
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

                PurchaseSuccess withCollection ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ View.Generic.Wallet.maybeView withCollection.wallet
                        , header
                        , Html.div
                            []
                            [ Html.text <|
                                String.concat
                                    [ "creator:"
                                    , " "
                                    , withCollection.handle
                                    ]
                            ]
                        , Html.div
                            []
                            [ Html.text "collection selected ⬇️"
                            ]
                        , Html.div
                            []
                            [ View.Generic.Collection.Collector.Collector.view
                                withCollection.handle
                                withCollection.collection
                            ]
                        ]

                MaybeExistingCreator _ ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ header
                        , Html.div
                            [ class "is-loading"
                            ]
                            []
                        ]

                MaybeExistingCollection _ _ ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ header
                        , Html.div
                            [ class "is-loading"
                            ]
                            []
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
