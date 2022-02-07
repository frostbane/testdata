{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# OPTIONS
   -Wall
   -Wno-unused-imports
   -Wno-unused-top-binds
   -fno-warn-partial-type-signatures
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
      hGetLine,
      hClose,
      hIsEOF,
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

procIfRight :: ()
            => (b -> Either a c)
            -> Either a b
            -> Either a c
procIfRight f e =
    case e of
        Left err -> Left err
        Right b  -> f b

closeCsvFile :: ()
             => Either T.Text Handle
             -> IO (Either T.Text (IO ()))
closeCsvFile eiHandle = do
    return $ procIfRight closeFileHandle eiHandle
  where
        closeFileHandle :: ()
                        => Handle
                        -> Either T.Text (IO ())
        closeFileHandle handle = Right $ hClose handle

parse :: ()
      => Either T.Text Handle
      -> IO (Either T.Text [T.Text])
parse eiHandle = do
    case eiHandle of
        Left err -> return $ Left err
        Right handle -> parseFile handle
  where
        parseFile :: ()
                  => Handle
                  -> IO (Either T.Text [T.Text])
        parseFile handle = do
            parseResult <- try (parseLine handle $ return ([] :: [T.Text])) :: IO (Either SomeException _)
            return $ case parseResult of
                Left ex      -> Left $ T.pack $ displayException ex
                Right result -> Right result

        parseLine :: ()
                  => Handle
                  -> IO [T.Text]
                  -> IO [T.Text]
        parseLine handle acc = do
            isEnd <- hIsEOF handle
            if isEnd
                then acc
                else do
                    currentLines <- acc
                    line         <- T.pack <$> hGetLine handle
                    parseLine handle $ return $ currentLines ++ [line]

