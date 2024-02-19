module App.Layer.Trip where

import Prelude

import App.Data.Route (Route(..))
import Data.Array.Partial (head)
import Data.Basic.Coordinates (Coordinates(..))
import Data.DateTime.Instant (unInstant)
import Data.DateTime.Instant as Instant
import Data.Foldable (maximum, minimum)
import Data.Maybe (fromJust)
import Data.Newtype (un)
import Data.Time.Duration (Milliseconds(..))
import DeckGL (Layer)
import DeckGL.Layer.Trips as Trips
import Partial.Unsafe (unsafePartial)
import WebMercator.LngLat (LngLat)
import WebMercator.LngLat as LngLat

mkTripsLayer :: forall p. { data :: Array TripR, time :: Number | p } -> Layer
mkTripsLayer props =
  Trips.makeTripsLayer
    $
      ( Trips.defaultTripsProps
          { id = "trip-layer"
          , data = props.data
          , getPath = _.path
          , getTimestamps = _.timestamps
          , currentTime = props.time
          , opacity = 0.9
          , getColor = const fallbackColor
          , trailLength = 0.05
          , visible = true
          }
      )

type TripR =
  { path :: Array LngLat
  , timestamps :: Array Number
  }

mkTripR :: Route -> TripR
mkTripR (Route route) =
  { path: (\(Coordinates c) -> LngLat.make { lng: c.lon, lat: c.lat }) <$> route.points
  , timestamps:
      let
        ts = (un Milliseconds <<< unInstant <<< Instant.fromDateTime) <$> route.timestamps
        start = unsafePartial $ fromJust $ minimum ts
        duration = (unsafePartial $ fromJust $ maximum ts) - start
      in
        (\t -> (t - start) / duration) <$> ts
  }

newtype Trip = Trip TripR

fallbackColor :: Array Number
fallbackColor = [ 253.0, 128.0, 93.0 ]