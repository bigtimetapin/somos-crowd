module Msg.Js exposing (Js(..))


type Js
    = Success Json
    | Error String


type alias Json =
    String
