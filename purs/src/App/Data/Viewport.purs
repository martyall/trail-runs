module App.Data.Viewport (initialViewport) where

import Prelude

import Data.Int (toNumber)
import Effect (Effect)
import Web.HTML (window)
import Web.HTML.Window as Window
import WebMercator.Viewport (ViewportR)

-- | Get the initial viewport based on the window dimensions.
initialViewport :: Effect (Record (ViewportR ()))
initialViewport = do
  win <- window
  w <- Window.innerWidth win
  h <- Window.innerHeight win
  pure
    { width: toNumber w
    , height: toNumber h
    , longitude: -35.0
    , latitude: 36.7
    , zoom: 1.8
    , pitch: 0.0
    , bearing: 0.0
    }
