module Msg.Msg exposing (Msg(..), resetViewport)

import Browser
import Browser.Dom as Dom
import Msg.Admin exposing (FromAdmin)
import Msg.Creator exposing (FromCreator)
import Msg.Js exposing (Js)
import Task
import Url


type
    Msg
    -- system
    = NoOp
    | UrlChanged Url.Url
    | LinkClicked Browser.UrlRequest
      -- creator
    | FromCreator FromCreator
      -- admin
    | FromAdmin FromAdmin
      -- js ports
    | FromJs Js


resetViewport : Cmd Msg
resetViewport =
    Task.perform (\_ -> NoOp) (Dom.setViewport 0 0)
