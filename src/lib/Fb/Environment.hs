{-# OPTIONS -Wall -Wno-unused-matches #-}
{-# LANGUAGE OverloadedStrings #-}

module Fb.Environment
    ( loadEnv
    , getEnvDefault
    ) where

import Prelude
import System.Environment ( setEnv
                          , lookupEnv
                          )
import System.IO ( openFile
                 , hGetLine
                 , hClose
                 , hIsEOF
                 , Handle
                 , IOMode (ReadMode)
                 )
import Control.Exception ( try
                         , SomeException
                         , displayException
                         )
import qualified Data.Text as T
import Data.Text (Text)
import Data.Maybe (fromMaybe)
import Text.Read (readMaybe)


splitPair :: String -> (String, String)
splitPair line = (key, val)
  where
    pair = T.breakOn "=" $ T.pack line
    key  = T.unpack $ T.strip $ fst pair
    val  = T.unpack $ T.strip $ T.drop 1 $ snd pair

parseEnv :: Handle -> IO Handle
parseEnv handle = do
    isEnd <- hIsEOF handle
    if isEnd then return handle
    else do
        line <- hGetLine handle
        let pair = splitPair line
        if fst pair == "" then return handle
        else do
            uncurry setEnv pair
            parseEnv handle

{- | returning IO (Either Text (IO())) will execute the Right (IO())
     only when needed (lazy)

     so I executed the IO inside the function and returned
     IO (Either Text ()) instead
    -}
loadEnv :: Text                 -- ^ environment file name
        -> IO (Either Text ())
loadEnv env = do
    let filename = T.unpack env
    fileOpenResult <- try (openFile filename ReadMode) :: IO (Either SomeException Handle)
    loadResult <- loadFileEnv fileOpenResult
    pure $ case fileOpenResult of
        Left ex      -> Left $ T.pack $ displayException ex
        Right handle -> Right loadResult
  where
    loadFileEnv result = case result of
        Right handle -> hClose =<< parseEnv handle
        _            -> return ()

{-| get environment variable value or use default if not foun

    environment key is case sensitived

    environment strings must be wrapped in quotes
    -}
getEnvDefault :: (Read a)
              => String    -- ^ environment key
              -> a         -- ^ default value if key is not found
              -> IO a
getEnvDefault key def = coalesce =<< lookupEnv key
  where
    coalesce result = case result of
        --Just val -> return $ fromMaybe def $ fromMaybe (readMaybe ("\"" ++ val ++ "\"")) $ readMaybe val
        Just val -> return $ fromMaybe def $ readMaybe val
        Nothing  -> return def
