{-# OPTIONS
 -Wno-partial-type-signatures
#-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultiWayIf #-}
{-# LANGUAGE PartialTypeSignatures #-}

module Server
    ( initialize
    , stat
    , getSpockConfig
    , getControllers
    , getHttpPort
    , Controller
    , Session
    ) where

import Fb.Environment
import Server.Controllers as Controllers
import Server.Types (Controller, Session, State(..))
import Web.Spock
import Web.Spock.Config
import Data.Map as M
import Data.IORef
import Data.Text (Text)
import qualified Network.HTTP.Types.Status as Http


initialize :: IO ()
initialize = do
    loadEnv ".env"
    return ()

stat :: IO ()
stat = putStrLn =<< getEnvironment

getSpockConfig :: ()
               => (Text -> IO())
               -> (Http.Status -> ActionCtxT () IO ())
               -> IO _ -- IO (SpockCfg () (a -> IO(SessionCfg () a ())) ())
getSpockConfig errLogger errHandler = do
--     let sess = defaultSessionCfg
    ref  <- newIORef M.empty
    sess <- newIORef M.empty
    defaultConf <- defaultSpockCfg sess PCNoDatabase (State ref)
    let cfg = defaultConf { spc_maxRequestSize = Just 512000
                          , spc_errorHandler   = errHandler
                          , spc_logError       = errLogger
                          , spc_csrfProtection = True
                          , spc_csrfHeaderName = "x-requested-with"
                          , spc_csrfPostName   = "x-csrf-token"
                          }
    return cfg

getControllers :: ()
               => IO [Controller]
getControllers = do
    env <- getEnvironment
    let app = [ Controllers.static
              , Controllers.basic
              ]
    let extra = if | env == "development" -> [Controllers.development]
                   | env == "staging"     -> []
                   | otherwise            -> []
    return $ app ++ extra

{- | get port from environment or the default 80 if it is not set

     make sure the HTTP_PORT value is an integer
    -}
getHttpPort :: IO Int
getHttpPort = getEnvDefault "HTTP_PORT" 80

getEnvironment :: IO String
getEnvironment = getEnvDefault "ENVIRONMENT" ("production" :: String)
