module Model.Creator.Existing.NewCollection exposing (NewCollection, default)

import Model.StringForm exposing (StringForm(..))


type alias NewCollection =
    { name : StringForm
    , symbol : StringForm
    }


default : NewCollection
default =
    { name = Typing ""
    , symbol = Typing ""
    }
