{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# OPTIONS
   -Wall
   -Wno-unused-top-binds
 #-}


module Arguments
    ( getArguments
    , normalizeArguments
    , get1stArgument
    ) where


import System.Environment (getArgs)
import qualified Data.Text as T


getArguments :: IO (Maybe [T.Text])
getArguments = do
    arguments <- getArgs
    return $
        case arguments of
            []   -> Nothing
            args -> Just $ map T.pack args

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

