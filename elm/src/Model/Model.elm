module Model.Model exposing (Model, init)

import Browser.Navigation as Nav
import Model.Collector as Collector
import Model.Handle as Handle
import Model.State as State exposing (State(..))
import Msg.Collector as FromCollector
import Msg.Msg exposing (Msg(..))
import Sub.Sender.Ports exposing (sender)
import Sub.Sender.Sender as Sender
import Url


type alias Model =
    { state : State
    , url : Url.Url
    , key : Nav.Key
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        state : State
        state =
            State.parse url

        model : Model
        model =
            { state = state
            , url = url
            , key = key
            }
    in
    case state of
        Collect (Collector.MaybeExisting handle) ->
            ( model
            , sender <|
                Sender.encode <|
                    { sender = Sender.Collect <| FromCollector.HandleForm <| Handle.Confirm handle
                    , more = Handle.encode handle
                    }
            )

        _ ->
            ( model
            , Cmd.none
            )
