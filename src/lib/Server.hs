{-# LANGUAGE OverloadedStrings #-}

module Server
    ( initialize
    , createSpockCfg
    , getHttpPort
    ) where

import Fb.Environment
import Web.Spock
import Web.Spock.Config
import Data.Text (Text)
import qualified Network.HTTP.Types.Status as Http


initialize :: IO()
initialize = do
    loadEnv ".env"
    return ()

createSpockCfg :: (Text -> IO())
               -> (Http.Status -> ActionCtxT () IO ())
               -> IO (SpockCfg () () ())
createSpockCfg errLogger errHandler = do
    defaultConf <- defaultSpockCfg () PCNoDatabase ()
    let cfg = defaultConf { spc_maxRequestSize = Just 512000
                          , spc_errorHandler   = errHandler
                          , spc_logError       = errLogger
                          , spc_csrfProtection = True
                          , spc_csrfHeaderName = "x-requested-with"
                          , spc_csrfPostName   = "x-csrf-token"
                          }
    return cfg

{- | get port from environment or the default 80 if it is not set

     make sure the HTTP_PORT value is an integer
    -}
getHttpPort :: IO Int
getHttpPort = getEnvDefault "HTTP_PORT" 80
