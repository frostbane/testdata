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
    sess <- defaultSessionCfg ()
    let cfg = SpockCfg ()
                   PCNoDatabase
                   sess
                   (Just 512000)
                   errHandler
                   errLogger
                   True
                   "x-akane"
                   "x-akane"

    runSpock 3000 $ spock cfg app
  where
    errLogger _ = return ()
    errHandler status@(Http.Status code message)
        | status == Http.notFound404  = text "Not Found 404"
        | otherwise                   = text "error"
    app :: SpockM () () () ()
    app = do
        middleware $ staticPolicy (addBase "static")
        get ("hello" <//> var) $
            \name -> do
                text ("Hello " <> name)

