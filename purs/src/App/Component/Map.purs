module App.Component.Map
  ( mapClass
  ) where

import Prelude

import App.Component.DeckGL (deckGLClass)
import App.Data.Meteorite (Meteorite, meteoriteLngLat)
import App.Request (buildIconMapping, getMeteoriteData)
import Data.Array (filter)
import Data.Int (floor, toNumber)
import DeckGL.Layer.Icon as Icon
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Uncurried (mkEffectFn1)
import Foreign.Object as Object
import MapGL as MapGL
import React as R
import Web.HTML (window)
import Web.HTML.Window as Window
import WebMercator.Viewport (ViewportR)
import WebMercator.Viewport as Viewport

--------------------------------------------------------------------------------
-- | Map Component
--------------------------------------------------------------------------------

mapClass :: R.ReactClass {}
mapClass = R.component "Map" \this -> do
  vp <- initialViewport
  launchAff_ do
    iconMapping <- buildIconMapping
    meteorites <- getMeteoriteData
    liftEffect $ R.modifyState this _
      { iconMapping = iconMapping
      , data = meteorites
      }

  pure
    { render: render this
    , state:
        { viewport: MapGL.Viewport vp
        , iconAtlas: iconAtlasUrl
        , iconMapping: Object.empty
        , data: []
        }
    }
  where
  render this = do
    state <- R.getState this
    let
      viewport@(MapGL.Viewport vp) = state.viewport
      relevantMeteorites = getMeteoritesInBoundingBox vp state.data

      mapProps = MapGL.mkProps viewport $
        { onViewportChange: mkEffectFn1 \newVp -> void $ R.modifyState this _ { viewport = newVp }
        , onClick: mkEffectFn1 (const $ pure unit)
        , mapStyle: mapStyle
        , mapboxApiAccessToken: mapboxApiAccessToken
        , dragRotate: false
        , onLoad: mempty
        , touchZoom: false
        , touchRotate: false
        }

      overlayProps =
        { viewport
        , data: relevantMeteorites
        , iconMapping: state.iconMapping
        , iconAtlas: state.iconAtlas
        , discreteZoom: floor vp.zoom
        }
    pure $ R.createElement MapGL.mapGL mapProps [ R.createLeafElement deckGLClass overlayProps ]

  getMeteoritesInBoundingBox :: Record (ViewportR ()) -> Array Meteorite -> Array Meteorite
  getMeteoritesInBoundingBox vp = filter
    $ Viewport.isInBoundingBox (Viewport.boundingBox $ Viewport.pack vp) <<< meteoriteLngLat

type MapState =
  { viewport :: MapGL.Viewport
  , iconAtlas :: String
  , iconMapping :: Icon.IconMapping
  , data :: Array Meteorite
  }

mapStyle :: String
mapStyle = "mapbox://styles/mapbox/dark-v9"

mapboxApiAccessToken :: String
mapboxApiAccessToken = "pk.eyJ1IjoiYmxpbmt5MzcxMyIsImEiOiJjamVvcXZtbGYwMXgzMzNwN2JlNGhuMHduIn0.ue2IR6wHG8b9eUoSfPhTuQ"

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

iconAtlasUrl :: String
iconAtlasUrl = "data/location-icon-atlas.png"