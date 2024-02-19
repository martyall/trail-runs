module App.Data.Meteorite
  ( Meteorite(..)
  , meteoriteId
  , meteoriteLngLat
  ) where

import Prelude

import Data.Argonaut as A
import Data.Array ((!!))
import Data.Maybe (fromJust)
import Data.Newtype (class Newtype)
import Partial.Unsafe (unsafePartial)
import WebMercator.LngLat (LngLat)
import WebMercator.LngLat as LngLat

newtype Meteorite =
  Meteorite
    { class :: String
    , coordinates :: Array Number
    , mass :: String
    , name :: String
    , year :: Int
    }

derive instance newtypeMeteorite :: Newtype Meteorite _

instance decodeJsonMeteorite :: A.DecodeJson Meteorite where

  decodeJson json = do
    obj <- A.decodeJson json
    _class <- obj A..: "class"
    coordinates <- obj A..: "coordinates"
    mass <- obj A..: "mass"
    name <- obj A..: "name"
    year <- obj A..: "year"
    pure $ Meteorite { class: _class, coordinates, mass, name, year }

-- | meteoriteId is effectively a hash of a meteorite.
meteoriteId :: Meteorite -> String
meteoriteId (Meteorite m) =
  m.class <> show m.coordinates <> m.mass <> m.name <> show m.year

-- | Convert the coordinates of a meteorite into LngLat
meteoriteLngLat :: Meteorite -> LngLat
meteoriteLngLat (Meteorite m) = LngLat.make $ unsafePartial fromJust $
  { lng: _, lat: _ }
    <$> m.coordinates !! 0
    <*> m.coordinates !! 1
