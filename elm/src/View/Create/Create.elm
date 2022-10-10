module View.Create.Create exposing (body)

import Html exposing (Html)
import Html.Attributes exposing (class, href, placeholder, target, type_)
import Html.Events exposing (onClick, onInput)
import Model.Creator.Creator exposing (Creator(..))
import Model.Creator.Existing as Existing
import Model.Creator.New as New
import Model.HandleForm as HandleForm
import Msg.Creator.Creator as CreatorMsg
import Msg.Creator.Existing as ExistingMsg
import Msg.Creator.New as NewMsg
import Msg.Msg exposing (Msg(..))
import View.Generic.Wallet


body : Creator -> Html Msg
body creator =
    let
        html =
            case creator of
                Top ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ header
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
                            [ Html.text
                                """Login as
                                """
                            , Html.button
                                [ class "is-button-1"
                                , onClick <|
                                    FromCreator <|
                                        CreatorMsg.Existing <|
                                            ExistingMsg.HandleForm <|
                                                HandleForm.Start
                                ]
                                [ Html.text "existing creator"
                                ]
                            , Html.text
                                """ or get started with a
                                """
                            , Html.button
                                [ class "is-button-1"
                                , onClick <| FromCreator <| CreatorMsg.New <| NewMsg.HandleForm <| HandleForm.Start
                                ]
                                [ Html.text "new profile"
                                ]
                            ]
                        ]

                New newCreator ->
                    case newCreator of
                        New.Top ->
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
                                                    FromCreator <|
                                                        CreatorMsg.New <|
                                                            NewMsg.HandleForm <|
                                                                HandleForm.TypingHandle s
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
                                ]

                        New.TypingHandle string ->
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
                                                        FromCreator <|
                                                            CreatorMsg.New <|
                                                                NewMsg.HandleForm <|
                                                                    HandleForm.ConfirmHandle string
                                                    ]
                                                    [ Html.text <|
                                                        String.concat
                                                            [ "proceed with handle as:"
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
                                                    FromCreator <|
                                                        CreatorMsg.New <|
                                                            NewMsg.HandleForm <|
                                                                HandleForm.TypingHandle s
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

                        New.WaitingForHandleConfirmation ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ header
                                , Html.div
                                    [ class "is-loading"
                                    ]
                                    []
                                ]

                        New.HandleInvalid string ->
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
                                                FromCreator <|
                                                    CreatorMsg.New <|
                                                        NewMsg.HandleForm <|
                                                            HandleForm.TypingHandle string
                                            ]
                                            [ Html.text
                                                """try again
                                                """
                                            ]
                                        ]
                                    ]
                                ]

                        New.HandleAlreadyExists string ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ header
                                , Html.div
                                    [ class "has-border-2 px-2 py-2"
                                    ]
                                    [ Html.text <|
                                        String.concat
                                            [ "input handle already exists:"
                                            , " "
                                            , string
                                            ]
                                    , Html.div
                                        [ class "pt-1"
                                        ]
                                        [ Html.button
                                            [ class "is-button-1"
                                            , onClick <|
                                                FromCreator <|
                                                    CreatorMsg.New <|
                                                        NewMsg.HandleForm <|
                                                            HandleForm.TypingHandle string
                                            ]
                                            [ Html.text
                                                """try again
                                                """
                                            ]
                                        ]
                                    ]
                                ]

                Existing existingCreator ->
                    case existingCreator of
                        Existing.Top ->
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
                                                    FromCreator <|
                                                        CreatorMsg.Existing <|
                                                            ExistingMsg.HandleForm <|
                                                                HandleForm.TypingHandle s
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
                                ]

                        Existing.HandleForm handleFormStatus ->
                            case handleFormStatus of
                                Existing.TypingHandle string ->
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
                                                                FromCreator <|
                                                                    CreatorMsg.Existing <|
                                                                        ExistingMsg.HandleForm <|
                                                                            HandleForm.ConfirmHandle string
                                                            ]
                                                            [ Html.text <|
                                                                String.concat
                                                                    [ "proceed with handle as:"
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
                                                            FromCreator <|
                                                                CreatorMsg.Existing <|
                                                                    ExistingMsg.HandleForm <|
                                                                        HandleForm.TypingHandle s
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

                                Existing.WaitingForHandleConfirmation ->
                                    Html.div
                                        [ class "has-border-2 px-2 pt-2 pb-6"
                                        ]
                                        [ header
                                        , Html.div
                                            [ class "is-loading"
                                            ]
                                            []
                                        ]

                                Existing.HandleInvalid string ->
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
                                                        FromCreator <|
                                                            CreatorMsg.Existing <|
                                                                ExistingMsg.HandleForm <|
                                                                    HandleForm.TypingHandle string
                                                    ]
                                                    [ Html.text
                                                        """try again
                                                        """
                                                    ]
                                                ]
                                            ]
                                        ]

                                Existing.HandleDoesNotExist string ->
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
                                                        FromCreator <|
                                                            CreatorMsg.Existing <|
                                                                ExistingMsg.HandleForm <|
                                                                    HandleForm.TypingHandle string
                                                    ]
                                                    [ Html.text
                                                        """try again
                                                        """
                                                    ]
                                                ]
                                            ]
                                        ]

                                Existing.UnAuthorized handle ->
                                    Html.div
                                        [ class "has-border-2 px-2 pt-2 pb-6"
                                        ]
                                        [ header
                                        , Html.div
                                            [ class "has-border-2 px-2 py-2"
                                            ]
                                            [ Html.text <|
                                                String.concat
                                                    [ "connected wallet is not authorized to manage handle:"
                                                    , " "
                                                    , handle
                                                    ]
                                            , Html.div
                                                [ class "pt-1"
                                                ]
                                                [ Html.button
                                                    [ class "is-button-1"
                                                    , onClick <|
                                                        FromCreator <|
                                                            CreatorMsg.Existing <|
                                                                ExistingMsg.HandleForm <|
                                                                    HandleForm.TypingHandle handle
                                                    ]
                                                    [ Html.text
                                                        """try again
                                                        """
                                                    ]
                                                ]
                                            ]
                                        ]

                        Existing.Authorized wallet handle ->
                            Html.div
                                [ class "has-border-2 px-2 pt-2 pb-6"
                                ]
                                [ View.Generic.Wallet.view wallet
                                , header
                                , Html.div
                                    []
                                    [ Html.text
                                        """authorized
                                        """
                                    ]
                                ]

                MaybeExisting string ->
                    Html.div
                        [ class "has-border-2 px-2 pt-2 pb-6"
                        ]
                        [ header
                        , Html.div
                            []
                            [ Html.text
                                """maybe existing
                                """
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
            [ Html.text "Creator Console"
            ]
        ]
