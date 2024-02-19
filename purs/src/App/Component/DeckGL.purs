module App.Component.DeckGL (deckGLClass) where

import Prelude

import App.Data.Meteorite (Meteorite, meteoriteId, meteoriteLngLat)
import App.Data.ZoomLevel (ZoomLevels, fillOutZoomLevels)
import App.Layer.Icon (mkIconLayer)
import Data.Newtype (unwrap)
import DeckGL as DeckGL
import DeckGL.Layer.Icon as Icon
import MapGL as MapGL
import RBush as RBush
import React as R
import WebMercator.Pixel as Pixel
import WebMercator.Viewport as Viewport

-- | Icon Layer Component
type MeteoriteProps =
  { viewport :: MapGL.Viewport
  , data :: Array Meteorite
  , iconMapping :: Icon.IconMapping
  , iconAtlas :: String
  , discreteZoom :: Int
  }

type MeteoriteState =
  { zoomLevels :: ZoomLevels
  }

deckGLClass :: R.ReactClass MeteoriteProps
deckGLClass = R.component "IconLayer" \this -> do
  props <- R.getProps this
  pure
    { unsafeComponentWillReceiveProps: componentWillReceiveProps this
    , render: render this
    , state: updateCluster props
    }
  where
  render this = do
    props <- R.getProps this
    state <- R.getState this

    let
      vp = unwrap props.viewport
      iconLayer = mkIconLayer props state
    pure
      $ R.createLeafElement DeckGL.deckGL
      $ DeckGL.defaultDeckGLProps { layers = [ iconLayer ], viewState = vp }

  componentWillReceiveProps :: R.ReactThis MeteoriteProps MeteoriteState -> R.ComponentWillReceiveProps MeteoriteProps
  componentWillReceiveProps this newProps = do
    currentProps <- R.getProps this
    if map meteoriteId newProps.data /= map meteoriteId currentProps.data || currentProps.discreteZoom /= newProps.discreteZoom then
      let
        newZL = updateCluster newProps
      in
        void $ R.writeState this newZL
    else pure unit

  updateCluster props =
    let
      vp = unwrap props.viewport
      vpZoomedOut = vp { zoom = 0.0 }
      prj = Viewport.project $ Viewport.pack vpZoomedOut
      bush = RBush.empty 5
      screenData = flip map props.data $ \d ->
        let
          sCoords = prj $ meteoriteLngLat d
        in
          { entry: d
          , x: Pixel.x sCoords
          , y: Pixel.y sCoords
          }
      fullBush = RBush.insertMany screenData bush
    in
      { zoomLevels: fillOutZoomLevels screenData fullBush props.discreteZoom }

