module Msg.Creator.Existing.NewCollectionForm exposing (NewCollectionForm(..))

import Model.Creator.Existing.NewCollection exposing (NewCollection)
import Model.StringForm exposing (StringForm)


type NewCollectionForm
    = Image
    | Name StringForm NewCollection
    | Symbol StringForm NewCollection
