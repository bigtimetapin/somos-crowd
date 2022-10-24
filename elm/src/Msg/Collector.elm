module Msg.Collector exposing (FromCollector(..), toString)

import Model.Collection exposing (Collection)
import Model.Handle as Handle exposing (Handle)


type FromCollector
    = HandleForm Handle.Form
    | SelectCollection Handle Collection


toString : FromCollector -> String
toString collector =
    case collector of
        HandleForm (Handle.Confirm _) ->
            "collector-search-handle"

        _ ->
            "no-op"
