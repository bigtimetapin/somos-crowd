module Sub.Sub exposing (subs)

import Msg.Admin as Admin
import Msg.Creator as Creator
import Msg.Generic as GenericMsg
import Msg.Msg exposing (Msg(..))
import Sub.Admin as AdminSub
import Sub.Creator as CreatorSub
import Sub.Generic exposing (genericError)


subs : Sub Msg
subs =
    Sub.batch
        [ -- creator sub
          CreatorSub.connectAsCreatorSuccess
            (\json ->
                ToCreator <| Creator.ConnectSuccess json
            )

        -- admin sub
        , AdminSub.connectAsAdminSuccess
            (\wallet ->
                ToAdmin <| Admin.ConnectSuccess wallet
            )
        , AdminSub.initializeTariffSuccess
            (\wallet ->
                ToAdmin <| Admin.InitializeTariffSuccess wallet
            )

        -- generic error
        , genericError
            (\error ->
                FromJs <| GenericMsg.Error error
            )
        ]
