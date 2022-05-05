{-# OPTIONS
 -Wall
 -Wno-unused-matches
#-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

import Lib
import Web.Spock
import Web.Spock.Lucid (lucid)
import Web.Spock.Config
import Network.Wai.Middleware.Static
import Lucid
import Data.Text (Text)
import qualified Data.Text as T
import qualified Network.HTTP.Types.Status as Http

createSpockCfg :: IO (SpockCfg () () ())
createSpockCfg = do
    defaultConf <- defaultSpockCfg () PCNoDatabase ()
    let cfg = defaultConf { spc_maxRequestSize = Just 512000
                          , spc_errorHandler   = errHandler
                          , spc_logError       = errLogger
                          , spc_csrfProtection = True
                          , spc_csrfHeaderName = "x-requested-with"
                          , spc_csrfPostName   = "x-csrf-token"
                          }
    return cfg
  where
    errLogger :: Text -> IO()
    errLogger _ = return ()
    errHandler :: Http.Status -> ActionCtxT () IO ()
    errHandler status@(Http.Status code message)
        | status == Http.notFound404  = h404
        | otherwise                   = text "error"
    h404 = lucid $ do
        h1_ "404"
        p_ "not found"

main :: IO ()
main = do
    cfg <- createSpockCfg
    runSpock 3000 $ spock cfg app
  where
    app :: SpockM () () () ()
    app = do
        middleware $ staticPolicy (addBase "static")
        get ("hello" <//> var) $
            \name -> do
                text ("Hello " <> name)

