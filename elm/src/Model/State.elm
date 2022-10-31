module Model.State exposing (State(..), href, parse)

import Html
import Html.Attributes
import Model.Admin as Administrator exposing (Admin)
import Model.Collector as Collector exposing (Collector)
import Model.Creator.Creator as Creator exposing (Creator)
import Url
import Url.Parser as UrlParser exposing ((</>))


type State
    = Create Creator
    | Collect Collector
    | Admin Admin
    | Error String


urlParser : UrlParser.Parser (State -> c) c
urlParser =
    UrlParser.oneOf
        [ UrlParser.map (Create Creator.Top) UrlParser.top
        , UrlParser.map (Create Creator.Top) (UrlParser.s "creator")
        , UrlParser.map
            (\handle -> Create (Creator.MaybeExisting handle))
            (UrlParser.s "creator" </> UrlParser.string)
        , UrlParser.map (Collect <| Collector.TypingHandle "") (UrlParser.s "collect")
        , UrlParser.map
            (\handle -> Collect (Collector.MaybeExistingCreator handle))
            (UrlParser.s "collect" </> UrlParser.string)
        , UrlParser.map
            (\handle index -> Collect (Collector.MaybeExistingCollection handle index))
            (UrlParser.s "collect" </> UrlParser.string </> UrlParser.int)
        , UrlParser.map (Admin Administrator.Top) (UrlParser.s "admin")
        ]


parse : Url.Url -> State
parse url =
    let
        target =
            -- The RealWorld spec treats the fragment like a path.
            -- This makes it *literally* the path, so we can proceed
            -- with parsing as if it had been a normal path all along.
            { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
    in
    case UrlParser.parse urlParser target of
        Just state ->
            state

        Nothing ->
            Error "404; Invalid Path"


path : State -> String
path state =
    case state of
        Admin _ ->
            "#/admin"

        Create _ ->
            "#/creator"

        Collect collector ->
            case collector of
                Collector.MaybeExistingCreator string ->
                    String.concat
                        [ "#/collect"
                        , "/"
                        , string
                        ]

                Collector.MaybeExistingCollection string int ->
                    String.join
                        "/"
                        [ "#/collect"
                        , string
                        , String.fromInt int
                        ]

                _ ->
                    "#/collect"


        Error _ ->
            "#/invalid"


href : State -> Html.Attribute msg
href state =
    Html.Attributes.href (path state)
