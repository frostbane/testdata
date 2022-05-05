{-# LANGUAGE OverloadedStrings #-}

module Server.Control.ErrorLogger
    ( handler
    ) where

import Data.Text (Text)


handler :: Text -> IO()
handler _ = return ()
