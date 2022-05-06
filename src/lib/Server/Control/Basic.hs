{-# LANGUAGE OverloadedStrings #-}

module Server.Control.Basic
    ( handler
    ) where

import Server.Types (Controller, Session)
import Web.Spock
import Web.Spock.Lucid (lucid)
import Lucid
import Data.Text (Text)



handler :: Controller
handler = do
    get root $ lucid $ do
        h4_ "testdata"
