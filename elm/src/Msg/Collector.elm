module Msg.Collector exposing (FromCollector(..), toString)

import Model.Handle as Handle exposing (Handle)


type FromCollector
    = HandleForm Handle.Form
    | SelectCollection Handle Int


toString : FromCollector -> String
toString collector =
    case collector of
        HandleForm (Handle.Confirm _) ->
            "collector-search-handle"

        SelectCollection _ _ ->
            "collector-select-collection"

        _ ->
            "no-op"