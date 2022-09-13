module Sub.Sub exposing (subs)

import Msg.Js exposing (Js(..))
import Msg.Msg exposing (Msg(..))
import Sub.Listener exposing (error, success)


subs : Sub Msg
subs =
    Sub.batch
        [ success
            (\json ->
                FromJs <| Success json
            )
        , error
            (\string ->
                FromJs <| Error string
            )
        ]
