module Lib
  ( someFunc,
    getTitle,
  )
where

someFunc :: IO ()
someFunc = putStrLn getTitle

getTitle :: String
getTitle = "akane"