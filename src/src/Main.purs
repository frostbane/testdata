module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Web.HTML (window)
import Web.HTML.Window (document)
import Web.HTML.HTMLDocument (toDocument)
import Web.HTML.HTMLElement (toElement, fromElement)
import Web.HTML.Event.EventTypes ( click
                                 , focus)
import Web.DOM.NonElementParentNode (getElementById)
import Web.DOM.Document (toNonElementParentNode)
import Web.DOM.Element ( toEventTarget
                       , fromNode)
import Web.Event.EventTarget ( eventListener
                             , addEventListener
                             , EventListener)
import Web.Event.Internal.Types (Event, EventTarget)
import Effect (Effect)
import Effect.Console (log)
import Effect.Exception (throw)

logClick :: Event -> Effect Unit
logClick _ = log "button clicked"

addEvent :: Maybe EventTarget -> Effect EventListener -> Effect Unit
addEvent target listener = do
    l <- listener
    case target of
        Just t  -> addEventListener click l true t
        Nothing -> pure unit

main :: Effect Unit
main = do
    w <- window
    doc <- document w
    buttonMaybe <- getElementById "myButton" $ toNonElementParentNode $ toDocument doc

    myEventTarget <- case buttonMaybe of
        -- Nothing -> throw "element with id 'myButton' not found."
        Nothing           -> pure Nothing
        Just myButtonElem -> pure $ Just $ toEventTarget myButtonElem

    let listener = eventListener logClick

    addEvent myEventTarget listener

