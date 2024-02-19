module App.Layer.Icon where

import Prelude

import App.Data.Icon (iconSize)
import App.Data.Meteorite (Meteorite, meteoriteId, meteoriteLngLat)
import App.Data.ZoomLevel (ZoomLevels)
import Data.Map as Map
import Data.Maybe (fromMaybe)
import Data.Tuple (Tuple(..))
import DeckGL (Layer)
import DeckGL.Layer.Icon as Icon

mkIconLayer
  :: forall p s
   . { data :: Array Meteorite
     , iconAtlas :: String
     , iconMapping :: Icon.IconMapping
     , discreteZoom :: Int
     | p
     }
  -> { zoomLevels :: ZoomLevels | s }
  -> Layer
mkIconLayer props state = Icon.makeIconLayer $
  ( Icon.defaultIconProps
      { id = "icon"
      , data = map (\m -> { meteorite: m }) props.data
      , pickable = false
      , visible = true
      , iconAtlas = props.iconAtlas
      , iconMapping = props.iconMapping
      , opacity = 1.0
      , sizeScale = 2.0 * iconSize
      , getPosition = \{ meteorite } -> meteoriteLngLat meteorite
      , getIcon = \{ meteorite } ->
          let
            mId = meteoriteId meteorite
          in
            fromMaybe "marker" (_.icon <$> Map.lookup (Tuple mId props.discreteZoom) (state.zoomLevels))
      , getSize = \{ meteorite } ->
          let
            mId = meteoriteId meteorite
          in
            fromMaybe 1.0 (_.size <$> Map.lookup (Tuple mId props.discreteZoom) state.zoomLevels)

      }
  )
