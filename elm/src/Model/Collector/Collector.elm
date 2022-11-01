module Model.Collector exposing (Collector(..))

import Model.WithCollection exposing (WithCollection)
import Model.WithCollections exposing (WithCollections)


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
