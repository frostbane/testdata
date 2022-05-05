{-# LANGUAGE OverloadedStrings #-}

module Server.Control.Basic
    ( handler
    ) where

import Web.Spock
import Network.Wai.Middleware.Static
import Data.Text (Text)



handler :: SpockM () () () ()
handler = do
    get ("hello" <//> var) $
        \name -> do
            text ("Hello " <> name)
