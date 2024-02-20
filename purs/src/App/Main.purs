module App.Main
  ( main
  ) where

import Prelude

import App.Component.Map (mapClass)
import Data.Maybe (fromJust)
import Effect (Effect)
import Partial.Unsafe (unsafePartial)
import React as R
import ReactDOM (render)
import Web.DOM (Element)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument as HTMLDocument
import Web.HTML.Window as Window

main :: Effect Unit
main = do
  enableLogging
  void $ elm' >>= render (R.createLeafElement mapClass {})
  where
  elm' :: Effect Element
  elm' = do
    win <- window
    doc <- Window.document win
    elm <- getElementById "root" (HTMLDocument.toNonElementParentNode doc)
    pure $ unsafePartial (fromJust elm)

foreign import enableLogging :: Effect Unit
