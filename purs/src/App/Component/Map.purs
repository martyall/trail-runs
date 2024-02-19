module App.Component.Map
  ( mapClass
  ) where

import Prelude

import App.Component.DeckGL (deckGLClass)
import App.Layer.Trip (TripR, mkTripR)
import App.Request (getRoute)
import Control.Monad.Rec.Class (forever)
import Data.Array (head)
import Data.Int (floor, toNumber)
import Data.Maybe (Maybe(..))
import Data.Number (pow, (%))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Milliseconds(..), delay, launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console as Console
import Effect.Uncurried (mkEffectFn1)
import MapGL as MapGL
import React as R
import Web.HTML (window)
import Web.HTML.Window as Window
import WebMercator.LngLat as LngLat
import WebMercator.Viewport (ViewportR)

--------------------------------------------------------------------------------
-- | Map Component
--------------------------------------------------------------------------------

mapClass :: R.ReactClass {}
mapClass = R.component "Map" \this -> do
  vp <- initialViewport
  launchAff_ do
    r <- getRoute
    let route = mkTripR r
    let
      start :: Maybe (LngLat.LngLat)
      start = head route.path

    let
      vp' = case start of
        Nothing -> vp
        Just s -> vp { latitude = LngLat.lat s, longitude = LngLat.lng s, zoom = 13.0 }
    liftEffect $ R.modifyState this _
      { data = [ route ]
      , viewport = MapGL.Viewport vp'
      }

  pure
    { render: render this
    , componentDidMount: componentDidMount this
    , state:
        { viewport: MapGL.Viewport vp
        , data: []
        , time: 0.0
        , currentSpeedFactor: 0.75
        }
    }
  where
  componentDidMount this = do

    launchAff_
      $ forever do
          currentSpeedFactor <- liftEffect do
            st <- R.getState this
            pure $ st.currentSpeedFactor `pow` 2.0
          delay $ Milliseconds 50.0
          liftEffect $ R.modifyState this $ \st ->
            let
              newTime = (st.time + 0.005 * currentSpeedFactor) % 1.1 -- not using 1.0 here because we want some time for fadeout
            in
              st { time = newTime }

  render this = do
    state <- R.getState this
    let
      viewport@(MapGL.Viewport vp) = state.viewport
      -- relevantMeteorites = getMeteoritesInBoundingBox vp state.data

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
        , data: state.data
        , discreteZoom: floor vp.zoom
        , time: state.time
        }
    pure $ R.createElement MapGL.mapGL mapProps [ R.createLeafElement deckGLClass overlayProps ]

--getMeteoritesInBoundingBox :: Record (ViewportR ()) -> Array Meteorite -> Array Meteorite
--getMeteoritesInBoundingBox vp = filter
--  $ Viewport.isInBoundingBox (Viewport.boundingBox $ Viewport.pack vp) <<< meteoriteLngLat

type MapState =
  { viewport :: MapGL.Viewport
  , data :: Array TripR
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