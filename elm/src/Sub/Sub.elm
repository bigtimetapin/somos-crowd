module Sub.Sub exposing (subs)

import Msg.Admin as Admin
import Msg.Generic as GenericMsg
import Msg.Msg exposing (Msg(..))
import Msg.Uploader as Uploader
import Sub.Admin as AdminSub
import Sub.Generic exposing (genericError)
import Sub.Uploader as UploaderSub


subs : Sub Msg
subs =
    Sub.batch
        [ -- uploader sub
          UploaderSub.connectAsUploaderSuccess
            (\json ->
                ToUploader <| Uploader.ConnectSuccess json
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
