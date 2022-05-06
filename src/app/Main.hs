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
    conf     <- Server.getSpockConfig Controllers.errorLog Controllers.error
    handlers <- Server.getControllers
    (spock conf $ (foldl1 (>>) $ handlers)) <* Server.stat

main :: IO ()
main = do
    Server.initialize
    port <- Server.getHttpPort
    runSpock port app
