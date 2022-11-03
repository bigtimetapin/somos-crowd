module Msg.Collector.Collector exposing (FromCollector(..), toString)

import Model.Handle as Handle exposing (Handle)
import Msg.Collector.PurchaseCollection as PurchaseCollection exposing (PurchaseCollection)


type FromCollector
    = HandleForm Handle.Form
    | SelectCollection Handle Int
    | PurchaseCollection PurchaseCollection


toString : FromCollector -> String
toString collector =
    case collector of
        HandleForm (Handle.Confirm _) ->
            "collector-search-handle"

        SelectCollection _ _ ->
            "collector-select-collection"

        PurchaseCollection (PurchaseCollection.Purchase _ _) ->
            "collector-purchase-collection"

        _ ->
            "no-op"
