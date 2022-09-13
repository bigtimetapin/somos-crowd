module Msg.Creator exposing (FromCreator(..), toString)


type
    FromCreator
    -- connect
    = Connect


toString : FromCreator -> String
toString fromCreator =
    case fromCreator of
        Connect ->
            "creator-connect"
