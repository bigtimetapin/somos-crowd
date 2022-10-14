module Main exposing (main)

-- MAIN

import Browser
import Browser.Navigation as Nav
import Html exposing (Html)
import Model.Admin as Administrator
import Model.Creator.Creator as Creator
import Model.Creator.Existing as ExistingCreator
import Model.Creator.New as NewCreator
import Model.Handle as Handle
import Model.HandleForm as HandleForm
import Model.Model as Model exposing (Model)
import Model.State as State exposing (State(..))
import Model.Wallet as Wallet
import Msg.Admin as AdminMsg
import Msg.Creator.Creator as FromCreator
import Msg.Creator.Existing as FromExistingCreator
import Msg.Creator.New as FromNewCreator
import Msg.Js as JsMsg
import Msg.Msg exposing (Msg(..), resetViewport)
import Sub.Listener.Creator.Creator as ToCreator
import Sub.Listener.Creator.Existing as ToExistingCreator
import Sub.Listener.Creator.New as ToNewCreator
import Sub.Listener.Listener as Listener
import Sub.Sender.Ports exposing (sender)
import Sub.Sender.Sender as Sender
import Sub.Sub as Sub
import Url
import View.Admin.Admin
import View.Create.Create
import View.Error.Error
import View.Hero


main : Program () Model Msg
main =
    Browser.application
        { init = Model.init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.subs
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UrlChanged url ->
            ( { model
                | state = State.parse url
                , url = url
              }
            , resetViewport
            )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        FromCreator from ->
            case from of
                FromCreator.New new ->
                    case new of
                        FromNewCreator.HandleForm handleForm ->
                            case handleForm of
                                HandleForm.Start ->
                                    ( { model | state = Create <| Creator.New <| NewCreator.TypingHandle "" }
                                    , Cmd.none
                                    )

                                HandleForm.TypingHandle string ->
                                    ( { model
                                        | state =
                                            Create <|
                                                Creator.New <|
                                                    NewCreator.TypingHandle <|
                                                        String.toLower string
                                      }
                                    , Cmd.none
                                    )

                                HandleForm.ConfirmHandle handle ->
                                    ( { model
                                        | state =
                                            Create <|
                                                Creator.New <|
                                                    NewCreator.WaitingForHandleConfirmation
                                      }
                                    , sender <|
                                        Sender.encode <|
                                            { sender = Sender.Create from, more = Handle.encode handle }
                                    )

                FromCreator.Existing existing ->
                    case existing of
                        FromExistingCreator.HandleForm handleForm ->
                            case handleForm of
                                HandleForm.Start ->
                                    ( { model
                                        | state =
                                            Create <|
                                                Creator.Existing <|
                                                    ExistingCreator.HandleForm <|
                                                        ExistingCreator.TypingHandle ""
                                      }
                                    , Cmd.none
                                    )

                                HandleForm.TypingHandle string ->
                                    ( { model
                                        | state =
                                            Create <|
                                                Creator.Existing <|
                                                    ExistingCreator.HandleForm <|
                                                        ExistingCreator.TypingHandle <|
                                                            String.toLower string
                                      }
                                    , Cmd.none
                                    )

                                HandleForm.ConfirmHandle handle ->
                                    ( { model
                                        | state =
                                            Create <|
                                                Creator.Existing <|
                                                    ExistingCreator.HandleForm
                                                        ExistingCreator.WaitingForHandleConfirmation
                                      }
                                    , sender <|
                                        Sender.encode <|
                                            { sender = Sender.Create from, more = Handle.encode handle }
                                    )

        FromAdmin from ->
            case from of
                AdminMsg.Connect ->
                    ( { model | state = Admin <| Administrator.WaitingForWallet }
                    , sender <| Sender.encode0 <| Sender.Administrate from
                    )

                AdminMsg.InitializeTariff wallet ->
                    ( { model | state = Admin <| Administrator.WaitingForInitializeTariff wallet }
                    , sender <| Sender.encode <| { sender = Sender.Administrate from, more = Wallet.encode wallet }
                    )

        FromJs fromJsMsg ->
            case fromJsMsg of
                -- JS sending success for decoding
                JsMsg.Success json ->
                    -- decode
                    case Listener.decode0 json of
                        -- decode success
                        Ok maybeListener ->
                            -- look for role
                            case maybeListener of
                                -- found role
                                Just listener ->
                                    -- which role?
                                    case listener of
                                        -- found msg for creator
                                        Listener.Create toCreator ->
                                            -- what is creator doing?
                                            case toCreator of
                                                ToCreator.New new ->
                                                    case new of
                                                        ToNewCreator.HandleInvalid ->
                                                            let
                                                                f handle =
                                                                    { model
                                                                        | state =
                                                                            Create <|
                                                                                Creator.New <|
                                                                                    NewCreator.HandleInvalid handle
                                                                    }
                                                            in
                                                            Listener.decode model json Handle.decode f

                                                        ToNewCreator.HandleAlreadyExists ->
                                                            let
                                                                f handle =
                                                                    { model
                                                                        | state =
                                                                            Create <|
                                                                                Creator.New <|
                                                                                    NewCreator.HandleAlreadyExists
                                                                                        handle
                                                                    }
                                                            in
                                                            Listener.decode model json Handle.decode f

                                                        ToNewCreator.NewHandleSuccess ->
                                                            let
                                                                f handleWithWallet =
                                                                    { model
                                                                        | state =
                                                                            Create <|
                                                                                Creator.Existing <|
                                                                                    ExistingCreator.Authorized
                                                                                        handleWithWallet.wallet
                                                                                        handleWithWallet.handle
                                                                    }
                                                            in
                                                            Listener.decode model json Handle.decodeWithWallet f

                                                ToCreator.Existing existing ->
                                                    case existing of
                                                        ToExistingCreator.HandleForm handleFormStatus ->
                                                            case handleFormStatus of
                                                                ToExistingCreator.Invalid ->
                                                                    let
                                                                        f handle =
                                                                            { model
                                                                                | state =
                                                                                    Create <|
                                                                                        Creator.Existing <|
                                                                                            ExistingCreator.HandleForm <|
                                                                                                ExistingCreator.HandleInvalid
                                                                                                    handle
                                                                            }
                                                                    in
                                                                    Listener.decode model json Handle.decode f

                                                                ToExistingCreator.DoesNotExist ->
                                                                    let
                                                                        f handle =
                                                                            { model
                                                                                | state =
                                                                                    Create <|
                                                                                        Creator.Existing <|
                                                                                            ExistingCreator.HandleForm <|
                                                                                                ExistingCreator.HandleDoesNotExist
                                                                                                    handle
                                                                            }
                                                                    in
                                                                    Listener.decode model json Handle.decode f

                                                                ToExistingCreator.UnAuthorized ->
                                                                    -- TODO; decode wallet
                                                                    let
                                                                        f handleWithWallet =
                                                                            { model
                                                                                | state =
                                                                                    Create <|
                                                                                        Creator.Existing <|
                                                                                            ExistingCreator.HandleForm <|
                                                                                                ExistingCreator.UnAuthorized
                                                                                                    handleWithWallet.wallet
                                                                                                    handleWithWallet.handle
                                                                            }
                                                                    in
                                                                    Listener.decode model json Handle.decodeWithWallet f

                                                                ToExistingCreator.Authorized ->
                                                                    let
                                                                        f handleWithWallet =
                                                                            { model
                                                                                | state =
                                                                                    Create <|
                                                                                        Creator.Existing <|
                                                                                            ExistingCreator.Authorized
                                                                                                handleWithWallet.wallet
                                                                                                handleWithWallet.handle
                                                                            }
                                                                    in
                                                                    Listener.decode model json Handle.decodeWithWallet f

                                -- undefined role
                                Nothing ->
                                    let
                                        message =
                                            String.join
                                                " "
                                                [ "Invalid role sent from client:"
                                                , json
                                                ]
                                    in
                                    ( { model | state = Error message }
                                    , Cmd.none
                                    )

                        -- error from decoder
                        Err string ->
                            ( { model | state = Error string }
                            , Cmd.none
                            )

                -- JS sending error to raise
                JsMsg.Error string ->
                    ( { model | state = Error string }
                    , Cmd.none
                    )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    let
        hero : Html Msg -> Html Msg
        hero =
            View.Hero.view model

        html =
            case model.state of
                Create creator ->
                    hero <| View.Create.Create.body creator

                Admin administrator ->
                    hero <| View.Admin.Admin.body administrator

                Error error ->
                    hero (View.Error.Error.body error)
    in
    { title = "somos-crowd"
    , body =
        [ html
        ]
    }
