{-# OPTIONS
 -Wall
 -Wno-unused-matches
#-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Server
import Server.Controllers as Controllers
import Web.Spock hiding (head)
import Network.Wai


app :: IO Middleware
app = do
    conf <- Server.createSpockCfg Controllers.errorLog Controllers.error
    let handlers = [ Controllers.development
                   , Controllers.static
                   , Controllers.basic
                   ]
    spock conf $ foldl (>>) (head handlers) (tail handlers)

main :: IO ()
main = do
    Server.initialize
    port <- Server.getHttpPort
    runSpock port app
