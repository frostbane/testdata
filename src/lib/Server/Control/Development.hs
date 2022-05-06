{-# LANGUAGE OverloadedStrings #-}

module Server.Control.Development
    ( handler
    ) where

import Server.Types (Controller, Session)
import Web.Spock
import Network.Wai.Middleware.Static
import Data.Text (Text)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)


handler :: Controller
handler = do
    middleware logStdoutDev

    get ("hello" <//> var) $
        \name -> do
            text ("Hello " <> name)
