module Server.Types
    ( Controller
    , Session
    , State (..)
    ) where

import Web.Spock
import Web.Spock.Config
import Data.Map (Map)
import Data.IORef
import Data.Text (Text)
import Database.PostgreSQL.Simple


newtype State = State
   { _session :: Session
   }

type Controller = SpockM Connection Session State ()

type Session = IORef (Map Text Text)

