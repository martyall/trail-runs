module App.Component.DeckGL (component) where

import Prelude

import App.Data.Route (Route, segmentRoute)
import App.Layer.Path (mkPathLayer)
import App.Layer.Terrain (mkTerrainLayer)
import App.Layer.Trip (Trip(..), mkTripR, mkTripsLayer)
import Control.Monad.Rec.Class (forever)
import Data.Array (cons, foldMap)
import Data.Foldable (traverse_)
import Data.Newtype (unwrap)
import Data.Number (pow, (%))
import DeckGL as DeckGL
import Effect.Aff (Fiber, Milliseconds(..), delay, error, killFiber, launchAff, launchAff_)
import Effect.Class (liftEffect)
import MapGL as MapGL
import React as R
import WebMercator.Viewport (pack)

type Props =
  { viewport :: MapGL.Viewport
  , data :: Array Route
  }

type State =
  { time :: Number
  , threads :: Array (Fiber Unit)
  }

component :: R.ReactClass Props
component = R.component "deck-gl" \this -> do
  pure
    { render: render this
    , state: { time: 0.0, threads: [] }
    , componentDidMount: componentDidMount this
    , componentWillUnmount: do
        { threads } <- R.getState this
        launchAff_ $ traverse_ (killFiber (error "cleanup")) threads
    }
  where

  render this = do
    props <- R.getProps this
    state <- R.getState this
    let
      tripsLayer = mkTripsLayer { data: Trip <<< mkTripR <$> props.data, time: 0.5 }
      pathsLayer = mkPathLayer { data: props.data }
    -- something is messaed up witht his one
    -- terrainLayer = mkTerrainLayer { viewport: pack $ unwrap props.viewport }

    pure
      $ R.createLeafElement DeckGL.deckGL
      $ DeckGL.defaultDeckGLProps { layers = [ tripsLayer, pathsLayer ], viewState = unwrap props.viewport, controller = true }
  componentDidMount this = mempty
-- thread <- launchAff
--   $ forever do
--       let currentSpeedFactor = 0.5 `pow` 2.0
--       delay $ Milliseconds 50.0
--       liftEffect $ R.modifyState this $ \st ->
--         let
--           newTime = (st.time + 0.005 * currentSpeedFactor) % 1.1 -- not using 1.0 here because we want some time for fadeout
--         in
--           st { time = newTime }
-- R.modifyState this \st -> st { threads = cons thread st.threads }