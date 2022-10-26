module Model.Collector exposing (Collector(..))

import Model.Collection exposing (Collection)
import Model.Creator.Existing.WithCollections exposing (WithCollections)
import Model.Handle exposing (Handle)
import Model.Wallet exposing (Wallet)


type
    Collector
    -- searching
    = TypingHandle String
    | WaitingForHandleConfirmation
    | HandleInvalid String
    | HandleDoesNotExist String
      -- selected
    | SelectedCreator WithCollections
    | SelectedCollection Handle Collection
    | WaitingForPurchase
    | PurchaseSuccess Wallet Handle Collection
      -- search by url
    | MaybeExisting String
