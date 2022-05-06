{-# LANGUAGE OverloadedStrings #-}

module Server.Control.Static
    ( handler
    ) where

import Server.Types (Controller, Session)
import Web.Spock
import Network.Wai.Middleware.Static
import Data.Text (Text)


handler :: Controller
handler = do
    middleware $ staticPolicy (addBase "static")
    middleware $ staticPolicy (addBase "public")
