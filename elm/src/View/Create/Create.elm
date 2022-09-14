module View.Create.Create exposing (body)

import Html exposing (Html)
import Html.Attributes exposing (class, href, style, target)
import Html.Events exposing (onClick)
import Model.Creator exposing (Creator(..))
import Msg.Creator as CreatorMsg
import Msg.Msg exposing (Msg(..))
import View.Generic.Wallet


body : Creator -> Html Msg
body creator =
    let
        html =
            case creator of
                Top ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6 pb-6"
                        ]
                        [ Html.button
                            [ class "is-button-1"
                            , onClick <| FromCreator <| CreatorMsg.Connect
                            , style "float" "right"
                            ]
                            [ Html.text "Connect"
                            ]
                        , header
                        , Html.div
                            [ class "pb-2"
                            ]
                            [ Html.text
                                """☑️
                                """
                            , Html.text
                                """Create new fungible & non-fungible
                                """
                            , Html.a
                                [ class "has-sky-blue-text"
                                , href "https://spl.solana.com/token"
                                , target "_blank"
                                ]
                                [ Html.text "spl-tokens"
                                ]
                            ]
                        , Html.div
                            [ class "pb-2"
                            ]
                            [ Html.text
                                """☑️
                                """
                            , Html.text
                                """Upload
                                """
                            , Html.a
                                [ class "has-sky-blue-text"
                                , href "https://litprotocol.com/"
                                , target "_blank"
                                ]
                                [ Html.text "token-gated"
                                ]
                            , Html.text
                                """ files for your community
                                """
                            ]
                        , Html.div
                            [ class "pb-2"
                            ]
                            [ Html.text
                                """☑️
                                """
                            , Html.text
                                """Source
                                """
                            , Html.a
                                [ class "has-sky-blue-text"
                                , href "https://docs.metaplex.com/programs/hydra/intro"
                                , target "_blank"
                                ]
                                [ Html.text "crowd-funding"
                                ]
                            , Html.text
                                """ for new projects
                                """
                            ]
                        , Html.div
                            [ class "pb-4"
                            ]
                            [ Html.text
                                """☑️
                                """
                            , Html.text
                                """Customize your own
                                """
                            , Html.a
                                [ class "has-sky-blue-text"
                                , href "https://solana.com/"
                                , target "_blank"
                                ]
                                [ Html.text "on-chain"
                                ]
                            , Html.text
                                """ profile to highlight your work
                                """
                            ]
                        , Html.div
                            []
                            [ Html.button
                                [ class "is-button-1"
                                , onClick <| FromCreator <| CreatorMsg.Connect
                                ]
                                [ Html.text "Connect"
                                ]
                            , Html.text
                                """ to get started or to edit your profile
                                """
                            ]
                        ]

                WaitingForWallet ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ header
                        , Html.div
                            [ class "my-2 is-loading"
                            ]
                            []
                        ]

                HasWallet wallet ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ View.Generic.Wallet.view wallet
                        , header
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
            [ Html.text "Creator Console"
            ]
        ]
