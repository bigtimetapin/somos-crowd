module View.Create.Create exposing (body)

import Html exposing (Html)
import Html.Attributes exposing (accept, class, href, id, placeholder, src, target, type_)
import Html.Events exposing (onClick, onInput)
import Model.Creator.Creator exposing (Creator(..))
import Model.Creator.Existing.Authorized as Authorized
import Model.Creator.Existing.Existing as Existing
import Model.Creator.Existing.HandleFormStatus as ExistingHandleFormStatus
import Model.Creator.New.New as New
import Model.StringForm as StringForm
import Msg.Creator.Creator as CreatorMsg
import Msg.Creator.Existing.Existing as ExistingMsg
import Msg.Creator.Existing.NewCollectionForm as NewCollectionForm
import Msg.Creator.New.New as NewMsg
import Msg.Msg exposing (Msg(..))
import View.Generic.Collection
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
                                        CreatorMsg.Existing
                                            ExistingMsg.StartHandleForm
                                ]
                                [ Html.text "existing creator"
                                ]
                            , Html.text
                                """ or get started with a
                                """
                            , Html.button
                                [ class "is-button-1"
                                , onClick <| FromCreator <| CreatorMsg.New <| NewMsg.StartHandleForm
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
                                                                StringForm.Typing s
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
                                                                    StringForm.Confirm string
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
                                                                StringForm.Typing s
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
                                                            StringForm.Typing string
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
                                                            StringForm.Typing string
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
                                                                StringForm.Typing s
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
                                ExistingHandleFormStatus.TypingHandle string ->
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
                                                                            StringForm.Confirm string
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
                                                                        StringForm.Typing s
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

                                ExistingHandleFormStatus.WaitingForHandleConfirmation ->
                                    Html.div
                                        [ class "has-border-2 px-2 pt-2 pb-6"
                                        ]
                                        [ header
                                        , Html.div
                                            [ class "is-loading"
                                            ]
                                            []
                                        ]

                                ExistingHandleFormStatus.HandleInvalid string ->
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
                                                                    StringForm.Typing string
                                                    ]
                                                    [ Html.text
                                                        """try again
                                                        """
                                                    ]
                                                ]
                                            ]
                                        ]

                                ExistingHandleFormStatus.HandleDoesNotExist string ->
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
                                                                    StringForm.Typing string
                                                    ]
                                                    [ Html.text
                                                        """try again
                                                        """
                                                    ]
                                                ]
                                            ]
                                        ]

                                ExistingHandleFormStatus.UnAuthorized wallet handle ->
                                    Html.div
                                        [ class "has-border-2 px-2 pt-2 pb-6"
                                        ]
                                        [ View.Generic.Wallet.view wallet
                                        , header
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
                                                                    StringForm.Typing handle
                                                    ]
                                                    [ Html.text
                                                        """try again
                                                        """
                                                    ]
                                                ]
                                            ]
                                        ]

                        Existing.Authorized authorized ->
                            case authorized of
                                Authorized.Top withCollections ->
                                    Html.div
                                        [ class "has-border-2 px-2 pt-2 pb-6"
                                        ]
                                        [ View.Generic.Wallet.view withCollections.wallet
                                        , header
                                        , Html.div
                                            []
                                            [ Html.text <|
                                                String.concat
                                                    [ "authorized as:"
                                                    , " "
                                                    , withCollections.handle
                                                    ]
                                            ]
                                        , Html.div
                                            []
                                            [ Html.button
                                                [ class "is-button-1"
                                                , onClick <|
                                                    FromCreator <|
                                                        CreatorMsg.Existing <|
                                                            ExistingMsg.StartCreatingNewCollection
                                                                withCollections.wallet
                                                                withCollections.handle
                                                ]
                                                [ Html.text "create new collection"
                                                ]
                                            ]
                                        , Html.div
                                            []
                                          <|
                                            List.map
                                                View.Generic.Collection.view
                                                withCollections.collections
                                        ]

                                Authorized.CreatingNewCollection wallet handle newCollection ->
                                    let
                                        imageForm =
                                            Html.div
                                                []
                                                [ Html.input
                                                    [ id "dap-cool-collection-logo-selector"
                                                    , type_ "file"
                                                    , accept <|
                                                        String.join
                                                            ", "
                                                            [ ".jpg"
                                                            , ".jpeg"
                                                            , ".png"
                                                            ]
                                                    , onClick <|
                                                        FromCreator <|
                                                            CreatorMsg.Existing <|
                                                                ExistingMsg.NewCollectionForm
                                                                    wallet
                                                                    handle
                                                                <|
                                                                    NewCollectionForm.Image
                                                    ]
                                                    []
                                                , Html.div
                                                    []
                                                    [ Html.img
                                                        [ src "images/upload/default-pfp.jpg"
                                                        , id "dap-cool-collection-logo"
                                                        ]
                                                        []
                                                    ]
                                                ]

                                        nameForm =
                                            case newCollection.name of
                                                StringForm.Typing string ->
                                                    let
                                                        confirm =
                                                            case string of
                                                                "" ->
                                                                    Html.div
                                                                        []
                                                                        []

                                                                _ ->
                                                                    Html.div
                                                                        [ class "is-button-1"
                                                                        , onClick <|
                                                                            FromCreator <|
                                                                                CreatorMsg.Existing <|
                                                                                    ExistingMsg.NewCollectionForm
                                                                                        wallet
                                                                                        handle
                                                                                    <|
                                                                                        NewCollectionForm.Name
                                                                                            (StringForm.Confirm string)
                                                                                            newCollection
                                                                        ]
                                                                        [ Html.text <|
                                                                            String.concat
                                                                                [ "confirm:"
                                                                                , " "
                                                                                , string
                                                                                ]
                                                                        ]
                                                    in
                                                    Html.div
                                                        []
                                                        [ Html.div
                                                            [ class "field"
                                                            ]
                                                            [ Html.p
                                                                [ class "control has-icons-left"
                                                                ]
                                                                [ Html.input
                                                                    [ class "input"
                                                                    , type_ "text"
                                                                    , placeholder "Name your new collection"
                                                                    , onInput <|
                                                                        \s ->
                                                                            FromCreator <|
                                                                                CreatorMsg.Existing <|
                                                                                    ExistingMsg.NewCollectionForm
                                                                                        wallet
                                                                                        handle
                                                                                    <|
                                                                                        NewCollectionForm.Name
                                                                                            (StringForm.Typing s)
                                                                                            newCollection
                                                                    ]
                                                                    []
                                                                , Html.span
                                                                    [ class "icon is-left"
                                                                    ]
                                                                    [ Html.i
                                                                        [ class "fas fa-file-signature"
                                                                        ]
                                                                        []
                                                                    ]
                                                                , confirm
                                                                ]
                                                            ]
                                                        ]

                                                StringForm.Confirm string ->
                                                    Html.div
                                                        []
                                                        [ Html.text <|
                                                            String.concat
                                                                [ "name:"
                                                                , " "
                                                                , string
                                                                ]
                                                        , Html.button
                                                            [ class "is-button-1"
                                                            , onClick <|
                                                                FromCreator <|
                                                                    CreatorMsg.Existing <|
                                                                        ExistingMsg.NewCollectionForm
                                                                            wallet
                                                                            handle
                                                                        <|
                                                                            NewCollectionForm.Name
                                                                                (StringForm.Typing "")
                                                                                newCollection
                                                            ]
                                                            [ Html.text "edit"
                                                            ]
                                                        ]

                                        symbolFrom =
                                            case newCollection.symbol of
                                                StringForm.Typing string ->
                                                    let
                                                        upper =
                                                            String.toUpper string

                                                        confirm =
                                                            case string of
                                                                "" ->
                                                                    Html.div
                                                                        []
                                                                        []

                                                                _ ->
                                                                    Html.div
                                                                        [ class "is-button-1"
                                                                        , onClick <|
                                                                            FromCreator <|
                                                                                CreatorMsg.Existing <|
                                                                                    ExistingMsg.NewCollectionForm
                                                                                        wallet
                                                                                        handle
                                                                                    <|
                                                                                        NewCollectionForm.Symbol
                                                                                            (StringForm.Confirm upper)
                                                                                            newCollection
                                                                        ]
                                                                        [ Html.text <|
                                                                            String.concat
                                                                                [ "confirm:"
                                                                                , " "
                                                                                , upper
                                                                                ]
                                                                        ]
                                                    in
                                                    Html.div
                                                        []
                                                        [ Html.div
                                                            [ class "field"
                                                            ]
                                                            [ Html.p
                                                                [ class "control has-icons-left"
                                                                ]
                                                                [ Html.input
                                                                    [ class "input"
                                                                    , type_ "text"
                                                                    , placeholder "Symbol"
                                                                    , onInput <|
                                                                        \s ->
                                                                            FromCreator <|
                                                                                CreatorMsg.Existing <|
                                                                                    ExistingMsg.NewCollectionForm
                                                                                        wallet
                                                                                        handle
                                                                                    <|
                                                                                        NewCollectionForm.Symbol
                                                                                            (StringForm.Typing s)
                                                                                            newCollection
                                                                    ]
                                                                    []
                                                                , Html.span
                                                                    [ class "icon is-left"
                                                                    ]
                                                                    [ Html.i
                                                                        [ class "fas fa-file-signature"
                                                                        ]
                                                                        []
                                                                    ]
                                                                , confirm
                                                                ]
                                                            ]
                                                        ]

                                                StringForm.Confirm string ->
                                                    Html.div
                                                        []
                                                        [ Html.text <|
                                                            String.concat
                                                                [ "symbol:"
                                                                , " "
                                                                , string
                                                                ]
                                                        , Html.button
                                                            [ class "is-button-1"
                                                            , onClick <|
                                                                FromCreator <|
                                                                    CreatorMsg.Existing <|
                                                                        ExistingMsg.NewCollectionForm
                                                                            wallet
                                                                            handle
                                                                        <|
                                                                            NewCollectionForm.Symbol
                                                                                (StringForm.Typing "")
                                                                                newCollection
                                                            ]
                                                            [ Html.text "edit"
                                                            ]
                                                        ]

                                        create =
                                            case ( newCollection.name, newCollection.symbol ) of
                                                ( StringForm.Confirm name, StringForm.Confirm symbol ) ->
                                                    Html.div
                                                        []
                                                        [ Html.button
                                                            [ class "is-button-1"
                                                            , onClick <|
                                                                FromCreator <|
                                                                    CreatorMsg.Existing <|
                                                                        ExistingMsg.CreateNewCollection
                                                                            wallet
                                                                            { handle = handle
                                                                            , name = name
                                                                            , symbol = symbol
                                                                            }
                                                            ]
                                                            [ Html.text "create"
                                                            ]
                                                        ]

                                                _ ->
                                                    Html.div
                                                        []
                                                        []

                                    in
                                    Html.div
                                        [ class "has-border-2 px-2 pt-2 pb-6"
                                        ]
                                        [ View.Generic.Wallet.view wallet
                                        , header
                                        , imageForm
                                        , nameForm
                                        , symbolFrom
                                        , create
                                        ]

                                Authorized.WaitingForNewCollectionCreation wallet ->
                                    Html.div
                                        [ class "has-border-2 px-2 pt-2 pb-6"
                                        ]
                                        [ View.Generic.Wallet.view wallet
                                        , header
                                        , Html.div
                                            [ class "is-loading"
                                            ]
                                            []
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
