module Msg.Creator exposing (From(..), To(..))

import Model.Wallet exposing (Wallet)


type
    From
    -- connect
    = Connect


type
    To
    -- connect
    = ConnectSuccess Wallet


type alias Json =
    String
