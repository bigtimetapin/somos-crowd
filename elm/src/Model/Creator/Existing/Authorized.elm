module Model.Creator.Existing.Authorized exposing (..)

import Model.Creator.Existing.NewCollection exposing (NewCollection)
import Model.Creator.Existing.WithCollections exposing (WithCollections)
import Model.Handle exposing (Handle)
import Model.Wallet exposing (Wallet)


type Authorized
    = Top WithCollections
    | CreatingNewCollection Wallet Handle NewCollection



-- WaitingForNewCollectionCreation Wallet
