module App.Layer.Terrain where

import Prelude

import DeckGL (Layer)
import DeckGL.Layers.Terrain (defaultTerrainProps, makeTerrainLayer)
import WebMercator.Viewport (Viewport)

mkTerrainLayer
  :: forall r
   . { viewport :: Viewport
     | r
     }
  -> Layer
mkTerrainLayer _ =
  makeTerrainLayer
    $
      ( defaultTerrainProps
          { id = "terrain"
          , visible = true
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
          , operation = "terrain"
          , strategy = "no-overlap"
          , minZoom = 10
          }
      )

terrainImageUrl :: String
terrainImageUrl = "https://api.mapbox.com/v4/mapbox.terrain-rgb/{z}/{x}/{y}.png?access_token=" <> mapboxApiAccessToken

surfaceImageUrl :: String
surfaceImageUrl = "https://api.mapbox.com/v4/mapbox.satellite/{z}/{x}/{y}@2x.png?access_token=" <> mapboxApiAccessToken

mapboxApiAccessToken :: String
mapboxApiAccessToken = "pk.eyJ1IjoiYmxpbmt5MzcxMyIsImEiOiJjamVvcXZtbGYwMXgzMzNwN2JlNGhuMHduIn0.ue2IR6wHG8b9eUoSfPhTuQ"