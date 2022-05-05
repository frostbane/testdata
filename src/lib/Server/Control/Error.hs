{-# LANGUAGE OverloadedStrings #-}

module Server.Control.Error
    ( handler
    ) where

import Web.Spock
import Web.Spock.Lucid (lucid)
import Network.Wai.Middleware.Static
import Lucid
import Data.Text (Text)
import qualified Network.HTTP.Types.Status as Http


handler :: Http.Status -> ActionCtxT () IO ()
handler status@(Http.Status code message)
    | status == Http.notFound404  = h404
    | otherwise                   = text "error"

h404 = lucid $ do
    h1_ "404"
    p_ "not found"

