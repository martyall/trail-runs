module DeckGL.Layer.Path where

import DeckGL (Layer)
import DeckGL.BaseProps (BaseProps)
import WebMercator.LngLat (LngLat)

foreign import defaultPathProps :: forall d. PathLayerProps d

foreign import makePathLayer :: forall d. PathLayerProps d -> Layer

type PathData d = { | d }

type PathLayerProps d = BaseProps
  ( widthUnits :: String
  , getPath :: PathData d -> Array LngLat
  , getColor :: PathData d -> Array Int
  , getWidth :: Int
  )
  (PathData d)