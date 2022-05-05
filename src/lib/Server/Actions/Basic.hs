{-# LANGUAGE OverloadedStrings #-}

module Server.Actions.Basic
    ( handler
    ) where

import Web.Spock
import Network.Wai.Middleware.Static
import Data.Text (Text)



handler :: SpockM () () () ()
handler = do

    middleware $ staticPolicy (addBase "static")

    get ("hello" <//> var) $
        \name -> do
            text ("Hello " <> name)
