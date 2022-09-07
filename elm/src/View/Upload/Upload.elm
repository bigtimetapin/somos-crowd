module View.Upload.Upload exposing (body)

import Html exposing (Html)
import Html.Attributes exposing (class, href, style, target)
import Html.Events exposing (onClick)
import Model.Uploader exposing (Uploader(..))
import Msg.Msg exposing (Msg(..))
import Msg.Uploader as UploaderMsg
import View.Generic.Wallet


body : Uploader -> Html Msg
body uploader =
    let
        html =
            case uploader of
                Top ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6 pb-6"
                        ]
                        [ Html.button
                            [ class "is-button-1"
                            , onClick <| FromUploader <| UploaderMsg.Connect
                            , style "float" "right"
                            ]
                            [ Html.text "Connect"
                            ]
                        , header
                        , Html.button
                            [ class "is-button-1"
                            , onClick <| FromUploader <| UploaderMsg.Connect
                            ]
                            [ Html.text "Connect"
                            ]
                        , Html.text
                            """ to upload
                            """
                        , Html.a
                            [ class "has-sky-blue-text"
                            , href "https://litprotocol.com/"
                            , target "_blank"
                            ]
                            [ Html.text "token-gated"
                            ]
                        , Html.text "-"
                        , Html.a
                            [ class "has-sky-blue-text"
                            , href "https://shdw.genesysgo.com/shadow-infrastructure-overview/shadow-drive-overview"
                            , target "_blank"
                            ]
                            [ Html.text "decentralized"
                            ]
                        , Html.text
                            """ files for your
                            """
                        , Html.a
                            [ class "has-sky-blue-text"
                            , href "https://spl.solana.com/token"
                            , target "_blank"
                            ]
                            [ Html.text "spl-token"
                            ]
                        , Html.text
                            """ community. 😎
                            """
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
                        [ header
                        , View.Generic.Wallet.view wallet
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
            [ Html.text "Upload Console"
            ]
        ]
