{-# LANGUAGE OverloadedStrings #-}
-- {-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE BlockArguments #-}

module Server.Control.Development
    ( handler
    ) where

import Fb.Lucid
import Server.Types
    ( Controller
    , Session
    , State(..)
    )
import Web.Spock
import Web.Spock.Lucid (lucid)
import Lucid
import Lucid.Base (makeAttribute)
import Data.Map as M
import Data.Map (Map)
import Data.Text as T
import Data.Text (Text)
import Data.IORef
import Network.Wai.Middleware.Static
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Data.Typeable
    ( typeOf
    , Typeable
    )
import Control.Monad.IO.Class (liftIO)


getTypeOfLn :: (Typeable a) => a -> Text
getTypeOfLn =  T.pack . show . typeOf

handler :: Controller
handler = do
    middleware logStdoutDev

    get ("hello" <//> var) $
        \name -> do
            text ("Hello " <> name)

    get "session" $ do
        sessId  <- getSessionId
        sessRef <- readSession
        sess    <- (liftIO . readIORef . session) =<< getState

        lucid do
            h4_ "session id"
            with table_ [border_ "1", width_ "100"] do
                tbody_ do
                    tr_ do
                        td_ "session id"
                        td_ $ toHtml sessId
            h4_ "session"
            table_ [border_ "1", width_ "100"] do
                thead_ do
                    tr_ do
                        th_ "key"
                        th_ "value"
                tbody_ do
                    tr_ do
                        td_ "id"
                        td_ $ toHtml $ M.findWithDefault "" "id" sess
                    tr_ do
                        td_ "name"
                        td_ $ toHtml $ M.findWithDefault "" "name" sess

        -- liftIO $ modifyIORef' sessRef $ Map.insert sessId (nameEntryName nameEntry)
        -- redirect "home"
