module App.Component.Map
  ( mapClass
  ) where

import Prelude

import App.Component.DeckGL as DeckGL
import App.Data.Route (Route)
import App.Request (getRoute)
import Data.Foldable (for_)
import Data.Int (toNumber)
import Data.Maybe (Maybe)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Uncurried (mkEffectFn1)
import MapGL as MapGL
import React as R
import Web.Event.Event as WE
import Web.Event.EventTarget as WET
import Web.HTML (window)
import Web.HTML.Window as WH.Window
import Web.HTML.Window as Window
import WebMercator.Viewport (ViewportR)

--------------------------------------------------------------------------------
-- | Map Component
--------------------------------------------------------------------------------

mapClass :: R.ReactClass {}
mapClass = R.component "Map" \this -> do
  vp <- initialViewport
  launchAff_ do
    r <- getRoute
    liftEffect $ R.modifyState this _
      { data = [ r ]
      , viewport = MapGL.Viewport vp
      }

  pure
    { render: render this
    , state:
        { viewport: MapGL.Viewport vp
        , data: ([] :: Array Route)
        }
    , componentDidMount: componentDidMount this
    }
  where
  render this = do
    state <- R.getState this
    let
      viewport = state.viewport
      mapProps = MapGL.mkProps viewport $
        { onViewportChange: mkEffectFn1 \newVp -> void $ R.modifyState this _ { viewport = newVp }
        , onClick: mkEffectFn1 (const $ pure unit)
        , mapStyle: mapStyle
        , mapboxApiAccessToken: mapboxApiAccessToken
        , dragRotate: true
        , onLoad: mempty
        , touchZoom: true
        , touchRotate: true
        }
      overlayProps =
        { viewport
        , data: state.data
        }
    pure $ R.createElement MapGL.mapGL mapProps [ R.createLeafElement DeckGL.component overlayProps ]

  componentDidMount this = do
    windowTarget <- WH.Window.toEventTarget <$> window
    let eventType = WE.EventType "resize"
    listener <- WET.eventListener $ \e ->
      for_ (WH.Window.fromEventTarget =<< WE.target e) $ \win -> do
        width <- toNumber <$> Window.innerWidth win
        height <- toNumber <$> Window.innerHeight win
        R.modifyState this $ \state -> { data: state.data, viewport: applyViewportDimensions { width, height } state.viewport }
    WET.addEventListener eventType listener true windowTarget

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
    , longitude: -122.7095
    , latitude: 42.1946
    , zoom: 15.0
    , pitch: 0.0
    , bearing: 0.0
    }

--------------------------------------------------------------------------------

type ViewportDimensions = { width :: Number, height :: Number }
type ViewportChanges =
  { latitude :: Maybe Number
  , longitude :: Maybe Number
  , zoom :: Maybe Number
  , pitch :: Maybe Number
  , bearing :: Maybe Number
  }

applyViewportDimensions
  :: ViewportDimensions
  -> MapGL.Viewport
  -> MapGL.Viewport
applyViewportDimensions { width: vdWidth, height: vdHeight } (MapGL.Viewport vp) =
  MapGL.Viewport $ vp { width = vdWidth, height = vdHeight }

{-
applyViewportChanges
  :: ViewportChanges
  -> MapGL.Viewport
  -> MapGL.Viewport
applyViewportChanges changes (MapGL.Viewport vp) = MapGL.Viewport vp'
  where
  vp' = vp { latitude = lat', longitude = lon', zoom = zoom', pitch = pitch', bearing = bearing' }
  lat' = fromMaybe vp.latitude changes.latitude
  lon' = fromMaybe vp.longitude changes.longitude
  zoom' = fromMaybe vp.zoom changes.zoom
  pitch' = fromMaybe vp.pitch changes.pitch
  bearing' = fromMaybe vp.bearing changes.bearing

defViewportChanges :: ViewportChanges
defViewportChanges =
  { latitude: Nothing
  , longitude: Nothing
  , zoom: Nothing
  , pitch: Nothing
  , bearing: Nothing
  }
-}