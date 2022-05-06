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

loadConfigHook :: IO ()
loadConfigHook = return ()

loadControllerHook :: IO ()
loadControllerHook = Server.stat

app :: IO Middleware
app = do
    conf     <- Server.getSpockConfig Controllers.errorLog Controllers.error loadConfigHook
    handlers <- Server.getControllers loadControllerHook
    spock conf $ foldl1 (>>) handlers

main :: IO ()
main = do
    Server.initialize
    port <- Server.getHttpPort
    runSpock port app
