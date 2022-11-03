module Msg.Collector.PurchaseCollection exposing (PurchaseCollection(..))

import Model.Handle exposing (Handle)


type PurchaseCollection
    = Purchase Handle Int
    | CouldNotFindWallet Handle Int
    | Success Handle Int
    | Failure String Handle Int
