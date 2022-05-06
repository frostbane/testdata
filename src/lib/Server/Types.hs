{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultiWayIf #-}
{-# LANGUAGE PartialTypeSignatures #-}

module Server.Types
    ( Controller
    , Session
    , State (State)
    ) where

import Web.Spock
import Web.Spock.Config
import Data.Map (Map)
import Data.IORef
import Data.Text (Text)


newtype State = State
   { st :: IORef (Map Text Text)
   }

type Controller = SpockM () Session State ()
type Session = IORef (Map Text Text)
