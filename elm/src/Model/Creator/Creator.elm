module Model.Creator.Creator exposing (Creator(..))

import Model.Creator.Existing exposing (Existing)
import Model.Creator.New exposing (New)

type Creator
    = Top
    | New New
    | Existing Existing
    | MaybeExisting String
