{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# OPTIONS -Wall #-}
{-# OPTIONS -Wno-unused-imports #-}
{-# OPTIONS -Wno-unused-top-binds #-}
{-# OPTIONS -fno-warn-partial-type-signatures #-}


module Csv
    ( checkFileExist
    , openCsvFile
    , closeCsvFile
    , parse
    , splitLine
    , showRes
    , showResName
    ) where


import System.Directory
    ( getCurrentDirectory
    , getDirectoryContents
    , doesFileExist
    )
import System.IO
    ( openFile
    , hGetLine
    , hClose
    , hIsEOF
    , Handle
    , IOMode (ReadMode, WriteMode)
    )
import Data.Typeable (typeOf)
import qualified Data.Text as T
import Data.Text (Text)
import Data.Text.IO (hPutStrLn)
import Data.Text.Lazy (fromStrict)
import Data.Text.Lazy.Encoding
    ( decodeUtf8
    , encodeUtf8
    )
import Data.Function
import Control.Monad
    ( liftM
    , mzero
    )
import Control.Monad.IO.Class (liftIO)
import Control.Exception
    ( try
    , SomeException
    , displayException
    )
import qualified Data.Vector as V
import Data.Vector (Vector)
import Data.Csv
import qualified Data.ByteString.Lazy as BL
import Data.Typeable
    ( typeOf
    , Typeable
    )

{- | Check if the file exists
    -}
checkFileExist :: ()
               => Either Text Text      -- ^ either the previous error or a filename
               -> IO (Either Text Text)
checkFileExist eiFileName = do
    case eiFileName of
        Left err       -> return $ Left err
        Right fileName -> do
            exist <- doesFileExist $ T.unpack fileName
            if not exist
            then return $ Left $ "'" <> fileName <> "' file does not exist."
            else return $ Right fileName

openCsvFile :: ()
         => Either Text Text      -- ^ either previous error or filename
         -> IOMode
         -> IO (Either Text Handle)
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
             => Either Text Handle
             -> IO (Either Text (IO ()))
closeCsvFile eiHandle = do
    return $ procIfRight closeFileHandle eiHandle
  where
        closeFileHandle :: ()
                        => Handle
                        -> Either Text (IO ())
        closeFileHandle handle = Right $ hClose handle

parse :: ()
      => Either Text Handle
      -> IO (Either Text [Text])
parse eiHandle = do
    case eiHandle of
        Left err     -> return $ Left err
        Right handle -> parseFile handle
  where
        parseFile :: ()
                  => Handle
                  -> IO (Either Text [Text])
        parseFile handle = do
            parseResult <- try (parseLine handle $ return ([] :: [Text])) :: IO (Either SomeException _)
            return $ case parseResult of
                Left ex      -> Left $ T.pack $ displayException ex
                Right result -> Right result
        -- | Read each line into a list until it reaches the end of file.
        parseLine :: ()
                  => Handle      -- ^ file handle
                  -> IO [Text] -- ^ accumulator
                  -> IO [Text] -- ^ lines read
        parseLine handle acc = do
            isEnd <- hIsEOF handle
            if isEnd
            then acc
            else do
                currentLines <- acc
                line         <- T.pack <$> hGetLine handle
                parseLine handle $ return $ currentLines ++ [line]

{- | Decode a Text to a Csv Vector

     Convert strict Text to Lazy the encode it as a Lazy Bytestring
     and decode as Csv
     -}
splitLine :: (FromRecord a)
          => Text
          -> Either String (Vector a)
splitLine a = decode NoHeader $ encodeUtf8 $ fromStrict a

{- | Decode a Text with Headers to a Csv Vector

     Convert strict Text to Lazy the encode it as a Lazy Bytestring
     and decode as Csv
     -}
splitLineWithHeader :: (FromNamedRecord a)
                    => Text
                    -> Either String (Header, Vector a)
splitLineWithHeader a = decodeByName $ encodeUtf8 $ fromStrict a

data Point = Point
    { m       :: !Int
    , d       :: !Int
    , name    ::  String
    , comment :: Maybe String
    }
    deriving (Eq, Show)


-- | creating a custom parser for Maybe String
--
--   cassava already defines a parser for Maybe String
--   so there is no need to create on
--
-- instance FromField (Maybe String)
--   where
--     parseField "" = pure Nothing
--     parseField s  = parseField s

{- | Parser instance for index based csv
   -}
instance FromRecord Point
  where
    parseRecord rec
        | length rec == 4 = createPoint rec
        | otherwise     = mzero
      where
            createPoint a = Point <$> a .! 0
                                  <*> a .! 1
                                  <*> a .! 2
                                  <*> a .! 3

{- | Parser instance for header based csv
   -}
instance FromNamedRecord Point
  where
    parseNamedRecord rec =
        Point <$> rec .: "m"
              <*> rec .: "d"
              <*> rec .: "name"
              <*> rec .: "comment"

{- | Parse a csv without headers using their index as the key
    -}
showRes :: String
showRes =
    case a of
        Left err -> show err
        Right v  -> show v
  where
        a :: Either String (Vector Point)
        a = splitLine $ "2, 1,'kix' ,\r\n12, 18, 'akane',k"

{- | Parse a csv with headers
    -}
showResName :: String
showResName =
    case a of
        Left err     -> show err
        Right (h, v) -> show h <> show v
  where
        a :: Either String (Header, Vector Point)
        a = splitLineWithHeader $ "name,m,d,comment\r\n'akane', 12, 18,\r\nkix, 2 , 1 ,a"

