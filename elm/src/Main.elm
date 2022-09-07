module Main exposing (main)

-- MAIN

import Browser
import Browser.Navigation as Nav
import Html exposing (Html)
import Model.Administrator as Administrator
import Model.Creator as Creator
import Model.Model as Model exposing (Model)
import Model.State as State exposing (State(..))
import Msg.Admin as AdminMsg
import Msg.Creator as CreatorMsg
import Msg.Generic as GenericMsg
import Msg.Msg exposing (Msg(..), resetViewport)
import Sub.Admin as AdminCmd
import Sub.Creator as CreatorCmd
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
                -- Waiting for wallet
                CreatorMsg.Connect ->
                    ( { model | state = Create <| Creator.WaitingForWallet }
                    , CreatorCmd.connectAsCreator ()
                    )

        ToCreator to ->
            case to of
                CreatorMsg.ConnectSuccess wallet ->
                    ( { model | state = Create <| Creator.HasWallet wallet }
                    , Cmd.none
                    )

        FromAdmin from ->
            case from of
                AdminMsg.Connect ->
                    ( { model | state = Admin <| Administrator.WaitingForWallet }
                    , AdminCmd.connectAsAdmin ()
                    )

                AdminMsg.InitializeTariff wallet ->
                    ( { model | state = Admin <| Administrator.WaitingForInitializeTariff wallet }
                    , AdminCmd.initializeTariff ()
                    )

        ToAdmin to ->
            case to of
                AdminMsg.ConnectSuccess wallet ->
                    ( { model | state = Admin <| Administrator.HasWallet wallet }
                    , Cmd.none
                    )

                AdminMsg.InitializeTariffSuccess wallet ->
                    ( { model | state = Admin <| Administrator.InitializedTariff wallet }
                    , Cmd.none
                    )

        FromJs fromJsMsg ->
            case fromJsMsg of
                GenericMsg.Error string ->
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
