module Model.Creator.Existing.Authorized exposing (..)

import Model.Handle exposing (Handle)
import Model.Wallet exposing (Wallet)


type Authorized
    = Top Wallet Handle
