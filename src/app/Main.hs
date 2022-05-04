{-# OPTIONS
 -Wall
 -Wno-unused-matches
#-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Lib
import Web.Spock
import Web.Spock.Config
import Network.Wai.Middleware.Static
import qualified Data.Text as T
import qualified Network.HTTP.Types.Status as Http

main :: IO ()
main = do
    cfg <- defaultSpockCfg () PCNoDatabase ()
    runSpock 3000 $ spock cfg app
  where
    app :: SpockM () () () ()
    app = do
        middleware $ staticPolicy (addBase "static")

