{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE OverloadedStrings    #-}
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
      IOMode (ReadMode, WriteMode),
    )
import Data.Typeable
    ( typeOf,
      Typeable,
    )
import qualified Data.Text as T
import Data.Text.IO (hPutStrLn)
import Control.Monad.IO.Class (liftIO)

import Csv
import Arguments


-- | Initialize encoding
--   initialize the envoding to utf8
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

-- | Print the provided argument's type
putTypeOfLn :: (Typeable a) => a -> IO ()
putTypeOfLn =  putStrLn . T.pack . show . typeOf

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

{- | Check if an argument is provided
    -}
checkArgument :: ()
              => Maybe T.Text
              -> Either T.Text T.Text
checkArgument mArgument =
  case mArgument of
      Nothing  -> Left $ T.pack "Invalid or missing arguments."
      Just arg -> Right arg

{- | stack run csv <file>
   -}
main :: IO ()
main = do
    arguments <- getArguments <* initEncoding
    -- putTypeOfLn arguments

    let fileName = (get1stArgument . normalizeArguments) arguments

    csvHandle <-  flip openCsvFile ReadMode
              =<< (checkFileExist . checkArgument) fileName

    parseResult <- parse csvHandle
    case parseResult of
        Left  err         -> putStrLn err >> putStrLn "" >> showHelp
        Right parsedLines -> mapM_ putStrLn parsedLines

    closeCsvFile csvHandle >> return ()

