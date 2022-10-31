module Model.Collector exposing (Collector(..))

import Model.Creator.Existing.WithCollections exposing (WithCollections)
import Model.WithCollection exposing (WithCollection)


type
    Collector
    -- searching
    = TypingHandle String
    | WaitingForHandleConfirmation
    | HandleInvalid String
    | HandleDoesNotExist String
      -- selected
    | SelectedCreator WithCollections
    | SelectedCollection WithCollection
    | WaitingForPurchase
    | PurchaseSuccess WithCollection
      -- search by url
    | MaybeExistingCreator String
    | MaybeExistingCollection String Int
