{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE BlockArguments #-}

module Fb.Lucid
    ( border_
    ) where

import Lucid
import Lucid.Base (makeAttribute)
import Data.Text (Text)


border_ :: Text -> Attribute
border_ = makeAttribute "border"

