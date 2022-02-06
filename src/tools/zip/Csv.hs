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
      openCsvFile,
      closeCsvFile,
      parse,
    )
  where


import System.Directory
    ( getCurrentDirectory,
      getDirectoryContents,
      doesFileExist,
    )
import System.IO
    ( openFile,
      hClose,
      Handle,
      IOMode (ReadMode, WriteMode),
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
import Control.Exception
    ( try,
      SomeException,
      displayException,
    )

{- | Check if the file exists
    -}
checkFileExist :: ()
               => Either T.Text T.Text      -- ^ either the previous error or a filename
               -> IO (Either T.Text T.Text)
checkFileExist eiFileName = do
    case eiFileName of
        Left err       -> return $ Left err
        Right fileName -> do
            exist <- doesFileExist $ T.unpack fileName
            if not exist
               then return $ Left $ "'" <> fileName <> "' file does not exist."
               else return $ Right fileName

openCsvFile :: ()
         => Either T.Text T.Text      -- ^ either previous error or filename
         -> IOMode
         -> IO (Either T.Text Handle)
openCsvFile eiFileName mode = do
    case eiFileName of
        Left err       -> return $ Left err
        Right fileName -> do
            result <- try (openFile filePath mode) :: IO (Either SomeException Handle)
            return $
                case result of
                    Left ex      -> Left $ T.pack $ displayException ex
                    Right handle -> Right handle
          where
                filePath = T.unpack fileName

closeCsvFile :: ()
             => Either T.Text Handle
             -> IO (Either T.Text (IO ()))
closeCsvFile eiHandle = do
    return closeFileHandle
  where
        closeFileHandle = do
            case eiHandle of
                Left err     -> Left err
                Right handle -> Right $ hClose handle

parse :: ()
      => Either T.Text Handle
      -> IO (Either T.Text Handle)
parse eiHandle = do
    return parseFile
  where
        parseFile = do
            case eiHandle of
                Left err     -> Left err
                Right handle -> Right handle

