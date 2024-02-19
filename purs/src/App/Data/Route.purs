module App.Data.Route where

import Prelude

import Control.Monad.Except (except, runExceptT, throwError)
import Control.Monad.Trans.Class (lift)
import Data.Argonaut (Json, decodeJson, printJsonDecodeError, (.:))
import Data.Array (concat, foldMap, head)
import Data.Basic.Coordinates (Coordinates)
import Data.Basic.LineStringCoordinates (toArray)
import Data.DateTime (DateTime)
import Data.Either (Either, either)
import Data.FeatureCollection (FeatureCollection(..))
import Data.Geometry (Geometry(..))
import Data.Geometry.Feature (Feature(..), FeatureProperties(..))
import Data.JSDate as JSDate
import Data.Maybe (Maybe(..))
import Data.MultiLineString (MultiLineString(..))
import Data.Profunctor.Choice (left)
import Data.Traversable (traverse)
import Effect (Effect)
import Effect.Exception (throw)

-- import Date.DateTime.ISO (ISO)

newtype Route = Route
  { timestamps :: Array DateTime
  , points :: Array Coordinates
  }

parseRoute :: Json -> Effect Route
parseRoute json = do
  route <- runExceptT do
    FeatureCollection { features } <- except $ left printJsonDecodeError $ decodeJson json
    case head features of
      Nothing -> lift $ throw "No features in FeatureCollection"
      Just f -> do
        timestamps <- lift $ parseTimestamps f
        points <- except $ parseCoordinates f
        pure $ Route { timestamps, points }
  either throw pure route

parseTimestamp :: String -> Effect DateTime
parseTimestamp s = do
  iso <- JSDate.parse s
  case JSDate.toDateTime iso of
    Just dt -> pure dt
    Nothing -> throw $ "Failed to parse timestamp: " <> s

parseTimestamps :: Feature -> Effect (Array DateTime)
parseTimestamps (Feature { properties }) =
  case properties of
    Nothing -> throw "Feature has no properties"
    Just (FeatureProperties props) -> do
      a <- runExceptT $ do
        obj <- (except $ decodeJson props)
        cts <- except (obj .: "coordTimes")
        lift $ traverse parseTimestamp (concat cts)
      either (throw <<< printJsonDecodeError) pure a

parseCoordinates :: Feature -> Either String (Array Coordinates)
parseCoordinates (Feature { geometry }) =
  case geometry of
    MultiLineString' (MultiLineString { coordinates }) -> pure $ foldMap toArray coordinates
    _ -> throwError "Feature geometry is not a MultiLineString"
