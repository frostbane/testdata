{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS
   -Wall
   -Wno-unused-imports
 #-}

module Main where

import Prelude hiding (putStrLn)
import qualified Prelude (putStrLn)
import System.Environment (getProgName)
import System.IO
    ( hSetEncoding,
      stdin,
      stdout,
      utf8,
    )
import Data.Typeable (typeOf)
import qualified Data.Text as T
import Data.Text.IO (hPutStrLn)


import Csv
import Arguments

{- | Initialize encoding
    -}
initEncoding :: IO ()
initEncoding = hSetEncoding stdin utf8
                    >> hSetEncoding stdout utf8

{-| Print a string with carriage return
    Shim of prelude's putStrLn
    @arguments Data.Text.Text string
    -}
putStrLn :: T.Text -> IO ()
putStrLn str = do
    hPutStrLn stdout str
    -- Prelude.putStrLn $ T.unpack str

showHelp :: IO ()
showHelp = do
    program <- T.pack <$> getProgName
    putStrLn $ program <> " - parse address and provide correct zip code"
    putStrLn ""
    putStrLn "Usage:"
    putStrLn $ "\t" <> program <> " <file>"

{- | Print an array of Maybe Data.Text.Text
    for debugging purposes
    -}
printArguments :: ()
               => Maybe [T.Text] -- ^ List of Maybe Text
               -> IO [()]
printArguments ms =
    case ms of
        Nothing   -> return [()]
        Just list -> mapM putStrLn list


{- | stack run csv <file>
   -}
main :: IO ()
main = do
    initEncoding
    arguments <- getArguments
    -- putStrLn $ T.pack $ show $ typeOf arguments
    let fileName = (get1stArgument . normalizeArguments) arguments
    case fileName of
        Nothing -> showHelp
        Just f  -> do
            checkResult <- checkFileExist f
            case checkResult of
                Left err -> putStrLn err >> showHelp
                Right _  -> putStrLn $ T.pack $ show fileName

