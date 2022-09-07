module Msg.Msg exposing (Msg(..), resetViewport)

import Browser
import Browser.Dom as Dom
import Msg.Admin as Admin
import Msg.Creator as Creator
import Msg.Generic exposing (FromJsMsg)
import Task
import Url


type
    Msg
    -- system
    = NoOp
    | UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
      -- creator sub
    | FromCreator Creator.From
    | ToCreator Creator.To
      -- admin sub
    | FromAdmin Admin.From
    | ToAdmin Admin.To
      -- generic js sub
    | FromJs FromJsMsg


resetViewport : Cmd Msg
resetViewport =
    Task.perform (\_ -> NoOp) (Dom.setViewport 0 0)
