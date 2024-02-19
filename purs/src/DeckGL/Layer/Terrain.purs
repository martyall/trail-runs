module DeckGL.Layers.Terrain where

import DeckGL (Layer)
import DeckGL.BaseProps (BaseProps)

foreign import defaultTerrainProps :: forall d. TerrainLayerProps d

foreign import makeTerrainLayer :: forall d. TerrainLayerProps d -> Layer

type TerrainData d = { | d }

type TerrainLayerProps d = BaseProps
  ( elevationData :: String
  , elevationDecoder :: ElevationDecoder
  , texture :: String
  , bounds :: Array Number
  , wireframe :: Boolean
  , color :: Array Int
  )
  (TerrainData d)

type ElevationDecoder =
  { rScaler :: Number
  , gScaler :: Number
  , bScaler :: Number
  , offset :: Int
  }