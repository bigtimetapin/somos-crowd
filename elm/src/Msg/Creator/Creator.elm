module Msg.Creator.Creator exposing (FromCreator(..), toString)

import Model.HandleForm exposing (HandleForm(..))
import Msg.Creator.Existing as Existing exposing (Existing)
import Msg.Creator.New as New exposing (New)


type FromCreator
    = New New
    | Existing Existing

toString : FromCreator -> String
toString fromCreator =
    case fromCreator of
        New new ->
            case new of
                New.HandleForm handleForm ->
                    case handleForm of
                        ConfirmHandle _ _ ->
                            "new-creator-confirm-handle"

                        _ ->
                            "no-op"


        Existing existing ->
            case existing of
                Existing.HandleForm handleForm ->
                    case handleForm of
                        ConfirmHandle _ _ ->
                            "existing-creator-confirm-handle"

                        _ ->
                            "no-op"


                Existing.InitializeCollection _ _ ->
                    "creator-initialize-collection"
