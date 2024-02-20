module App.Component.DeckGL (component) where

import Prelude

import App.Layer.Trip (Trip, mkTripsLayer)
import Control.Monad.Rec.Class (forever)
import Data.Array (cons)
import Data.Foldable (traverse_)
import Data.Newtype (unwrap)
import Data.Number (pow, (%))
import DeckGL as DeckGL
import Effect.Aff (Fiber, Milliseconds(..), delay, error, killFiber, launchAff, launchAff_)
import Effect.Class (liftEffect)
import MapGL as MapGL
import React as R

type Props =
  { viewport :: MapGL.Viewport
  , data :: Array Trip
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
      tripsLayer = mkTripsLayer { data: props.data, time: state.time }

    pure
      $ R.createLeafElement DeckGL.deckGL
      $ DeckGL.defaultDeckGLProps { layers = [ tripsLayer ], viewState = unwrap props.viewport, controller = true }
  componentDidMount this = do
    thread <- launchAff
      $ forever do
          let currentSpeedFactor = 0.5 `pow` 2.0
          delay $ Milliseconds 50.0
          liftEffect $ R.modifyState this $ \st ->
            let
              newTime = (st.time + 0.005 * currentSpeedFactor) % 1.1 -- not using 1.0 here because we want some time for fadeout
            in
              st { time = newTime }
    R.modifyState this \st -> st { threads = cons thread st.threads }