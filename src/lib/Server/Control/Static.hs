{-# LANGUAGE OverloadedStrings #-}

module Server.Control.Static
    ( handler
    ) where

import Web.Spock
import Network.Wai.Middleware.Static
import Data.Text (Text)



handler :: SpockM () () () ()
handler = do
    middleware $ staticPolicy (addBase "static")
    middleware $ staticPolicy (addBase "public")
