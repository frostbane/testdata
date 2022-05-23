{-# OPTIONS
 -Wno-partial-type-signatures
#-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE PartialTypeSignatures #-}

module Database
    ( createDatabaseConnection
    ) where

import Fb.Environment
import Data.Map as M
import Data.IORef
import Data.Text (Text)
import Web.Spock
import Web.Spock.Config
import Database.PostgreSQL.Simple


getConnInfo :: IO ConnectInfo
getConnInfo = do
    return ConnectInfo { connectHost     = "persistence"
                       , connectPort     = 5432
                       , connectUser     = "testdata"
                       , connectPassword = "a7a2E"
                       , connectDatabase = "testdata"
                       }

createConnection :: IO Connection
createConnection = connect =<< getConnInfo

createConnectionBuilder :: IO (ConnBuilder _)
createConnectionBuilder = do
    let poolCfg = PoolCfg { pc_stripes      = 1
                          , pc_resPerStripe = 1
                          , pc_keepOpenTime = 30
                          }
    return ConnBuilder { cb_createConn        = connect =<< getConnInfo
                       , cb_destroyConn       = close
                       , cb_poolConfiguration = poolCfg
                       }

createDatabaseConnection :: IO (PoolOrConn _)
createDatabaseConnection = do
    conBuilder <- createConnectionBuilder
    return $ PCConn conBuilder


