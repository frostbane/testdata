{-# LANGUAGE OverloadedStrings #-}

module Server.Actions.ErrorLogger
    ( handler
    ) where

import Data.Text (Text)


handler :: Text -> IO()
handler _ = return ()
