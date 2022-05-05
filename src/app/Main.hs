{-# OPTIONS
 -Wall
 -Wno-unused-matches
#-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Server
import Server.Actions as Actions
import Web.Spock hiding (middleware)
import Network.Wai


middleware :: IO Middleware
middleware = do
    conf <- Server.createSpockCfg Actions.errorLogger Actions.errorHandler
    spock conf Actions.basicHandler

main :: IO ()
main = do
    port <- Server.getHttpPort
    runSpock port middleware
