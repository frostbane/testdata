{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS
   -Wall
   -Wno-unused-imports
   -Wno-unused-top-binds
 #-}


module Csv
    ( parse
    )
  where


import Prelude hiding (putStrLn)
import qualified Prelude (putStrLn)
import System.Environment
    ( getArgs,
      getProgName,
    )
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

getArguments :: IO (Maybe [T.Text])
getArguments = do
    arguments <- getArgs
    return $
        case arguments of
            []   -> Nothing
            args -> Just $ map T.pack args

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

checkFileExist :: ()
               => T.Text
               -> IO (Either T.Text T.Text)
checkFileExist fileName = do
    exist <- doesFileExist $ T.unpack fileName
    if exist
       then return $ Right fileName
       else return $ Left $ "'" <> fileName <> "' file does not exist."

normalizeArguments :: ()
                   => Maybe [T.Text]
                   -> Maybe [T.Text]
normalizeArguments mArgs =
    case mArgs of
        Nothing -> Nothing
        Just args
            | length args > 1 -> Nothing
            | otherwise       -> Just args

get1stArgument :: ()
               => Maybe [T.Text]
               -> Maybe T.Text
get1stArgument mText =
  case mText of
      Nothing   -> Nothing
      Just list -> Just $ head list

parse :: IO ()
parse = do
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
