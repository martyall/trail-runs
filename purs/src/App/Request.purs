module App.Request
  ( buildIconMapping
  , getMeteoriteData
  , getRoute
  ) where

import Prelude

import Affjax as Affjax
import Affjax.RequestHeader (RequestHeader(..))
import Affjax.ResponseFormat (json)
import Affjax.Web (driver)
import App.Data.Icon (IconEntry(..))
import App.Data.Meteorite (Meteorite)
import App.Data.Route (Route, parseRoute)
import Data.Argonaut as A
import Data.Array (foldl)
import Data.Either (Either(..), either)
import DeckGL.Layer.Icon as Icon
import Effect.Aff (Aff, error, throwError)
import Effect.Class (liftEffect)
import Foreign.Object as Object

-- | Make a request to the data directory to make the `IconMapping`, which is just a mapping
-- | from label name (e.g. marker-1) to the section of the imageAtlas which you can find the
-- | right icon.
buildIconMapping :: Aff Icon.IconMapping
buildIconMapping = do
  resp <- Affjax.get driver json iconUrl
  (icons :: Array IconEntry) <- case resp of
    Left e -> throwError $ error $ Affjax.printError e
    Right { body } -> either (throwError <<< error <<< show) pure $ A.decodeJson body
  pure $ foldl (\mapping icon -> Object.insert (makeLabel icon) (makeEntry icon) mapping) Object.empty icons
  where
  makeLabel (IconEntry icon) = icon.label
  makeEntry (IconEntry icon) =
    { x: icon.x
    , y: icon.y
    , width: icon.width
    , height: icon.height
    , mask: false
    }

  iconUrl :: String
  iconUrl = "data/location-icon-mapping.json"

-- | Fetch the meteorite data from the data directory.
getMeteoriteData :: Aff (Array Meteorite)
getMeteoriteData = do
  let
    req = Affjax.defaultRequest
      { url = meteoritesUrl
      , headers =
          [ RequestHeader "Access-Control-Allow-Origin" "*"
          , RequestHeader "Contenty-Type" "application/json"
          ]
      , responseFormat = json
      }
  resp <- Affjax.request driver req
  case resp of
    Left e -> throwError <<< error $ Affjax.printError e
    Right { body } -> either (throwError <<< error <<< show) pure $ A.decodeJson body
  where
  -- | data directory urls.
  meteoritesUrl :: String
  meteoritesUrl = "data/meteorites.json"

getRoute :: Aff Route
getRoute = do
  let
    req = Affjax.defaultRequest
      { url = routeUrl
      , headers =
          [ RequestHeader "Access-Control-Allow-Origin" "*"
          , RequestHeader "Contenty-Type" "application/json"
          ]
      , responseFormat = json
      }
  resp <- Affjax.request driver req
  case resp of
    Left e -> throwError <<< error $ Affjax.printError e
    Right { body } -> liftEffect $ parseRoute body
  where
  -- | data directory urls.
  routeUrl :: String
  routeUrl = "data/route.json"