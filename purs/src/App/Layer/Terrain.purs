module App.Layer.Terrain where

import Prelude

import DeckGL (Layer)
import DeckGL.Layers.Terrain (defaultTerrainProps, makeTerrainLayer)
import WebMercator.LngLat (lat, lng)
import WebMercator.Viewport (Viewport, boundingBox)

mkTerrainLayer
  :: forall r
   . { viewport :: Viewport
     | r
     }
  -> Layer
mkTerrainLayer { viewport } =
  makeTerrainLayer
    $
      ( defaultTerrainProps
          { bounds =
              let
                { sw, ne } = boundingBox viewport
              in
                [ lng sw, lat sw, lng ne, lat ne ]
          , elevationData = terrainImageUrl
          , texture = surfaceImageUrl
          , elevationDecoder =
              { rScaler: 6553.6
              , gScaler: 25.6
              , bScaler: 0.1
              , offset: -10000
              }
          , wireframe = false
          , color = [ 255, 255, 255 ]
          }
      )

mapTilerKey :: String
mapTilerKey = "tj1wb0snXj90DYL73Dlp"

terrainImageUrl :: String
terrainImageUrl = "https://api.maptiler.com/tiles/terrain-rgb-v2/{z}/{x}/{y}.webp?key=" <> mapTilerKey

surfaceImageUrl :: String
surfaceImageUrl = "https://api.maptiler.com/tiles/satellite-v2/{z}/{x}/{y}.jpg?key=" <> mapTilerKey