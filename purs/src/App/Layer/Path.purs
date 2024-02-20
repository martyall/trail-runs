module App.Layer.Path where

import Prelude

import App.Data.Route (Route(..), Segment(..))
import Data.Array (take)
import Data.Basic.Coordinates (Coordinates(..))
import Data.DateTime.Instant (unInstant)
import Data.DateTime.Instant as Instant
import Data.Foldable (maximum, minimum)
import Data.Maybe (fromJust)
import Data.Newtype (un)
import Data.Time.Duration (Milliseconds(..))
import Debug (trace)
import DeckGL (Layer)
import DeckGL.Layer.Path as Path
import Partial.Unsafe (unsafePartial)
import WebMercator.LngLat (LngLat)
import WebMercator.LngLat as LngLat

mkPathLayer :: forall r. { data :: Array Route | r } -> Layer
mkPathLayer { data: d } =
  Path.makePathLayer
    $
      ( Path.defaultPathProps
          { id = "path-layer"
          , data = (\(Route r) -> r) <$> d
          , getPath = \a -> f <$> a.points
          , getColor = const fallbackColor
          , opacity = 0.9
          , visible = true
          }
      )

  where
  f (Coordinates c) =
    LngLat.make { lng: c.lon, lat: c.lat }

fallbackColor :: Array Int
fallbackColor = [ 255, 232, 0 ]