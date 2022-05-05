{-# LANGUAGE OverloadedStrings #-}

module Server.Controllers
    ( error
    , errorLog
    , static
    , basic
    , development
    ) where

import Prelude hiding (error)
import Server.Control.Error
import Server.Control.Static
import Server.Control.ErrorLogger
import Server.Control.Basic
import Server.Control.Development


error       = Server.Control.Error.handler
errorLog    = Server.Control.ErrorLogger.handler
static      = Server.Control.Static.handler
basic       = Server.Control.Basic.handler
development = Server.Control.Development.handler

