module Msg.Collector exposing (FromCollector(..), toString)

import Model.Handle as Handle


type FromCollector
    = HandleForm Handle.Form


toString : FromCollector -> String
toString collector =
    case collector of
        HandleForm (Handle.Confirm _) ->
            "collector-search-handle"

        _ ->
            "no-op"
