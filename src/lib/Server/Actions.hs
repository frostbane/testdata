{-# LANGUAGE OverloadedStrings #-}

module Server.Actions
    ( errorHandler
    , errorLogger
    , basicHandler
    ) where

import Server.Actions.Error
import Server.Actions.ErrorLogger
import Server.Actions.Basic


errorHandler = Server.Actions.Error.handler
errorLogger  = Server.Actions.ErrorLogger.handler
basicHandler = Server.Actions.Basic.handler
