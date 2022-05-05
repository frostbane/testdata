{-# LANGUAGE OverloadedStrings #-}

module Server.Control.Basic
    ( handler
    ) where

import Web.Spock
import Web.Spock.Lucid (lucid)
import Lucid
import Data.Text (Text)



handler :: SpockM () () () ()
handler = do
    get root $ lucid $ do
        h4_ "testdata"
