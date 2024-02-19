module App.Component.DeckGL (deckGLClass) where

import Prelude

import App.Layer.Trip (TripR, mkTripsLayer)
import Data.Newtype (unwrap)
import DeckGL as DeckGL
import MapGL as MapGL
import React as R

-- | Icon Layer Component
type MeteoriteProps =
  { viewport :: MapGL.Viewport
  , data :: Array TripR
  , discreteZoom :: Int
  , time :: Number
  }

type MeteoriteState = {}

deckGLClass :: R.ReactClass MeteoriteProps
deckGLClass = R.component "IconLayer" \this -> do
  props <- R.getProps this
  pure
    --{ unsafeComponentWillReceiveProps: componentWillReceiveProps this
    { render: render this
    , state: {}
    }
  where
  render this = do
    props <- R.getProps this

    let tripsLayer = mkTripsLayer props
    pure
      $ R.createLeafElement DeckGL.deckGL
      $ DeckGL.defaultDeckGLProps { layers = [ tripsLayer ], viewState = unwrap props.viewport }

--componentWillReceiveProps :: R.ReactThis MeteoriteProps MeteoriteState -> R.ComponentWillReceiveProps MeteoriteProps
--componentWillReceiveProps this newProps = do
--  currentProps <- R.getProps this
--  if map meteoriteId newProps.data /= map meteoriteId currentProps.data || currentProps.discreteZoom /= newProps.discreteZoom then
--    let
--      newZL = updateCluster newProps
--    in
--      void $ R.writeState this newZL
--  else pure unit

--updateCluster props =
--  let
--    vp = unwrap props.viewport
--    vpZoomedOut = vp { zoom = 0.0 }
--    prj = Viewport.project $ Viewport.pack vpZoomedOut
--    bush = RBush.empty 5
--    screenData = flip map props.data $ \d ->
--      let
--        sCoords = prj $ meteoriteLngLat d
--      in
--        { entry: d
--        , x: Pixel.x sCoords
--        , y: Pixel.y sCoords
--        }
--    fullBush = RBush.insertMany screenData bush
--  in
--    { zoomLevels: fillOutZoomLevels screenData fullBush props.discreteZoom }

