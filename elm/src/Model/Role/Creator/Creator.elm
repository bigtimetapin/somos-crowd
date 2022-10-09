module Model.Role.Creator.Creator exposing (ToCreator(..), fromString)

import Model.Role.Creator.Existing as Existing exposing (Existing)
import Model.Role.Creator.New as New exposing (New)

type ToCreator
    = New New
    | Existing Existing


fromString : String -> Maybe ToCreator
fromString string =
    case Existing.fromString string of
        Just existing ->
            Just <| Existing existing


        Nothing ->
            case New.fromString string of
                Just new ->
                    Just <| New new


                Nothing ->
                    Nothing
