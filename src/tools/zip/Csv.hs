{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS
   -Wall
   -Wno-unused-imports
   -Wno-unused-top-binds
 #-}


module Csv
    ( checkFileExist,
      parse,
    )
  where


import System.Directory
    ( getCurrentDirectory,
      getDirectoryContents,
      doesFileExist,
    )
import System.IO
    ( hSetEncoding,
      stdin,
      stdout,
      utf8,
    )
import Data.Typeable (typeOf)
import qualified Data.Text as T
import Data.Text.IO (hPutStrLn)
import Data.Text.Encoding
    ( decodeUtf8,
      encodeUtf8,
    )
import Data.Function
import Control.Monad (liftM)
import Control.Monad.IO.Class (liftIO)

checkFileExist :: ()
               => T.Text
               -> IO (Either T.Text T.Text)
checkFileExist fileName = do
    exist <- doesFileExist $ T.unpack fileName
    if exist
       then return $ Right fileName
       else return $ Left $ "'" <> fileName <> "' file does not exist."

parse :: IO ()
parse = do
    return ()
