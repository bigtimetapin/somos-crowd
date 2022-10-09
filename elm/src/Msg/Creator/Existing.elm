module Msg.Creator.Existing exposing (Existing(..))

import Model.Wallet exposing (Wallet)
import Model.AlmostCollection exposing (AlmostCollection)
import Model.HandleForm exposing (HandleForm)

type Existing
    = HandleForm HandleForm
      -- create new collection
    | InitializeCollection Wallet AlmostCollection
