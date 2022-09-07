module Main exposing (main)

-- MAIN

import Browser
import Browser.Navigation as Nav
import Html exposing (Html)
import Model.Administrator as Administrator
import Model.Model as Model exposing (Model)
import Model.State as State exposing (State(..))
import Model.Uploader as Uploader
import Msg.Admin as AdminMsg
import Msg.Generic as GenericMsg
import Msg.Msg exposing (Msg(..), resetViewport)
import Msg.Uploader as UploaderMsg
import Sub.Admin as AdminCmd
import Sub.Sub as Sub
import Sub.Uploader as UploaderCmd
import Url
import View.Admin.Admin
import View.Error.Error
import View.Hero
import View.Upload.Upload


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

        FromUploader from ->
            case from of
                -- Waiting for wallet
                UploaderMsg.Connect ->
                    ( { model | state = Upload <| Uploader.WaitingForWallet }
                    , UploaderCmd.connectAsUploader ()
                    )

        ToUploader to ->
            case to of
                UploaderMsg.ConnectSuccess wallet ->
                    ( { model | state = Upload <| Uploader.HasWallet wallet }
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
                Upload uploader ->
                    hero <| View.Upload.Upload.body uploader

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
