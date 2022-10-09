module Main exposing (main)

-- MAIN

import Browser
import Browser.Navigation as Nav
import Html exposing (Html)
import Model.Admin as Administrator
import Model.Creator.Creator as Creator
import Model.Creator.Existing as Existing
import Model.Creator.New as NewCreator
import Model.Handle as Handle
import Model.HandleForm as HandleForm
import Model.Model as Model exposing (Model)
import Model.Role.Creator.Existing as ToExistingCreator
import Model.Role.Creator.New as ToNewCreator
import Model.Role.Listener as Listener
import Model.Role.Sender as Sender
import Model.State as State exposing (State(..))
import Model.Wallet as Wallet
import Msg.Admin as AdminMsg
import Msg.Creator.Creator as FromCreator
import Msg.Creator.New as FromNewCreator
import Msg.Creator.Existing as FromExistingCreator
import Msg.Js as JsMsg
import Msg.Msg exposing (Msg(..), resetViewport)
import Sub.Sender exposing (sender)
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
                                HandleForm.Start wallet ->
                                    ( { model | state = Create <| Creator.New <| NewCreator.TypingHandle wallet ""}
                                    , Cmd.none
                                    )

                                HandleForm.TypingHandle wallet string ->
                                    ( { model | state = Create <| Creator.New <| NewCreator.TypingHandle wallet string }
                                    , Cmd.none
                                    )


                                HandleForm.ConfirmHandle wallet handle ->
                                    ( { model | state = Create <| Creator.New <|
                                        NewCreator.WaitingForHandleConfirmation wallet
                                        }
                                    , sender <|
                                        Sender.encode <|
                                            { sender = Sender.Create from, more = Handle.encode handle }
                                    )




                FromCreator.Existing existing ->
                    case existing of
                        FromExisting.HandleForm handleForm ->


                        FromExisting.InitializeCollection wallet almostCollection ->




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
                                                FromCreator.New new ->
                                                    case new of
                                                        FromNew.HandleInvalid ->
                                                            let
                                                                f handleWithWallet =
                                                                    { model | state = Create <|
                                                                        Creator.New <|
                                                                            NewCreator.HandleInvalid
                                                                                handleWithWallet.wallet
                                                                                handleWithWallet.handle
                                                                    }
                                                            in
                                                            Listener.decode2 model json Handle.decode f


                                                        FromNew.HandleAlreadyExists ->
                                                            let
                                                                f handleWithWallet =
                                                                    { model | state = Create <|
                                                                        Creator.New <|
                                                                            NewCreator.HandleAlreadyExists
                                                                                handleWithWallet.wallet
                                                                                handleWithWallet.handle
                                                                    }
                                                            in
                                                            Listener.decode2 model json Handle.decode f



                                                        FromNew.NewHandleSuccess ->
                                                            let
                                                                f handleWithWallet =
                                                                    { model | state = Create <|
                                                                        Creator.Existing <|
                                                                            Existing.Authorized
                                                                                handleWithWallet.wallet
                                                                                handleWithWallet.handle
                                                                    }
                                                            in
                                                            Listener.decode2 model json Handle.decode f



                                                FromCreator.Existing existing ->
                                                    case existing of
                                                        FromExisting.HandleForm handleFormStatus ->
                                                            case handleFormStatus of
                                                                FromExisting.Invalid ->
                                                                    let
                                                                        f handleWithWallet =
                                                                            { model | state = Create <|
                                                                                Creator.Existing <|
                                                                                    Existing.HandleForm
                                                                                        handleWithWallet.wallet <|
                                                                                        Existing.HandleInvalid
                                                                                            handleWithWallet.handle
                                                                            }
                                                                    in
                                                                    Listener.decode2 model json Handle.decode f


                                                                FromExisting.DoesNotExist ->
                                                                    let
                                                                        f handleWithWallet =
                                                                            { model | state = Create <|
                                                                                Creator.Existing <|
                                                                                    Existing.HandleForm
                                                                                        handleWithWallet.wallet <|
                                                                                        Existing.HandleDoesNotExist
                                                                                            handleWithWallet.handle
                                                                            }
                                                                    in
                                                                    Listener.decode2 model json Handle.decode f


                                                                FromExisting.UnAuthorized ->
                                                                    let
                                                                        f handleWithWallet =
                                                                            { model | state = Create <|
                                                                                Creator.Existing <|
                                                                                    Existing.HandleForm
                                                                                        handleWithWallet.wallet <|
                                                                                        Existing.UnAuthorized
                                                                                            handleWithWallet.handle
                                                                            }
                                                                    in
                                                                    Listener.decode2 model json Handle.decode f


                                                                FromExisting.Authorized ->
                                                                    let
                                                                        f handleWithWallet =
                                                                            { model | state = Create <|
                                                                                Creator.Existing <|
                                                                                    Existing.Authorized
                                                                                        handleWithWallet.wallet
                                                                                        handleWithWallet.handle
                                                                            }
                                                                    in
                                                                    Listener.decode2 model json Handle.decode f



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
