{-# LANGUAGE OverloadedStrings #-}

module Server.Control.Development
    ( handler
    ) where

import Web.Spock
import Network.Wai.Middleware.Static
import Data.Text (Text)
import Network.Wai.Middleware.RequestLogger (logStdoutDev)


handler :: SpockM () () () ()
handler = do
    middleware logStdoutDev
