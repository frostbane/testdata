{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultiWayIf #-}

module Server
    ( initialize
    , getSpockConfig
    , getControllers
    , getHttpPort
    ) where

import Fb.Environment
import Server.Controllers as Controllers
import Web.Spock
import Web.Spock.Config
import Data.Text (Text)
import qualified Network.HTTP.Types.Status as Http


initialize :: IO()
initialize = do
    loadEnv ".env"
    return ()

getSpockConfig :: (Text -> IO())
               -> (Http.Status -> ActionCtxT () IO ())
               -> IO (SpockCfg () () ())
getSpockConfig errLogger errHandler = do
    defaultConf <- defaultSpockCfg () PCNoDatabase ()
    let cfg = defaultConf { spc_maxRequestSize = Just 512000
                          , spc_errorHandler   = errHandler
                          , spc_logError       = errLogger
                          , spc_csrfProtection = True
                          , spc_csrfHeaderName = "x-requested-with"
                          , spc_csrfPostName   = "x-csrf-token"
                          }
    return cfg

type Handler = SpockM () () () ()

getControllers :: IO [Handler]
getControllers = do
    env <- getEnvironment
    let app = [ Controllers.static
              , Controllers.basic
              ]
    let extra = if | env == "development" -> [Controllers.development]
                   | env == "staging"     -> []
                   | otherwise            -> []
    putStrLn $ show env
    return $ app ++ extra

{- | get port from environment or the default 80 if it is not set

     make sure the HTTP_PORT value is an integer
    -}
getHttpPort :: IO Int
getHttpPort = getEnvDefault "HTTP_PORT" 80

getEnvironment :: IO String
getEnvironment = getEnvDefault "ENVIRONMENT" ("production" :: String)
