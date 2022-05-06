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
    )
import Web.Spock
import Web.Spock.Lucid (lucid)
import Lucid
import Lucid.Base (makeAttribute)
import Data.Map as M
import Data.Map (Map)
import Data.Text as T
import Data.Text (Text)
import Network.Wai.Middleware.Static
import Network.Wai.Middleware.RequestLogger (logStdoutDev)
import Data.Typeable
    ( typeOf
    , Typeable
    )


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

        lucid do
            with table_ [border_ "1", width_ "100"] do
                tr_ do
                    td_ "session id"
                    td_ $ toHtml sessId

        -- text ("<p>" <> (T.pack $ show sessId) <> "</p>")

        -- liftIO $ modifyIORef' sessRef $ Map.insert sessId (nameEntryName nameEntry)
        -- redirect "home"

