module App.Data.ZoomLevel
  ( ZoomLevelData
  , ZoomLevels
  , fillOutZoomLevel
  , fillOutZoomLevels
  ) where

import Prelude

import App.Data.Icon (getIconName, getIconSize, iconSize)
import App.Data.Meteorite (Meteorite, meteoriteId)
import Control.Monad.Reader (ReaderT, ask, runReaderT)
import Control.Monad.State (State, execState, get, modify_)
import Data.Array (filter, length)
import Data.Foldable (for_)
import Data.Int (toNumber)
import Data.Map as Map
import Data.Number (pow)
import Data.Set as S
import Data.Tuple (Tuple(..))
import RBush as RBush

type ZoomLevelData =
  { icon :: String
  , size :: Number
  }

-- | For a given Meteorite (with meteoriteId) and zoom level n
-- | return the zoom level data, if there is any
type ZoomLevels = Map.Map (Tuple String Int) ZoomLevelData

type ZoomLevelState = { knownSet :: S.Set String, zoomLevels :: ZoomLevels }

fillOutZoomLevel
  :: Array (RBush.Node Meteorite)
  -> Int
  -> ReaderT (RBush.RBush Meteorite) (State ZoomLevelState) Unit
fillOutZoomLevel ms zoom = for_ ms $ \{ x, y, entry } -> do
  bush <- ask
  known <- _.knownSet <$> get
  if entryZoomHash entry `S.member` known then pure unit
  else
    let
      box =
        { minX: x - radius
        , minY: y - radius
        , maxX: x + radius
        , maxY: y + radius
        }
      allNeighbors = RBush.search box bush
      newNeighbors = filter (\n -> not $ entryZoomHash n.entry `S.member` known) allNeighbors
    in
      for_ newNeighbors $ \node ->
        let
          nodeId = meteoriteId node.entry
        in
          if nodeId == meteoriteId entry then modify_ \s -> s
            { zoomLevels = Map.insert (Tuple nodeId zoom)
                { icon: getIconName $ length newNeighbors
                , size: getIconSize $ length newNeighbors
                }
                s.zoomLevels
            , knownSet = S.insert (entryZoomHash node.entry) s.knownSet
            }
          else modify_ \s -> s
            { knownSet = S.insert (entryZoomHash node.entry) s.knownSet
            }
  where
  entryZoomHash e = meteoriteId e <> show zoom
  radius = iconSize / (2.0 `pow` toNumber (zoom + 1))

fillOutZoomLevels
  :: Array (RBush.Node Meteorite)
  -> RBush.RBush Meteorite
  -> Int
  -> ZoomLevels
fillOutZoomLevels nodes bush zoom =
  let
    initialState = { knownSet: S.empty, zoomLevels: Map.empty }
  in
    _.zoomLevels $ execState (runReaderT (fillOutZoomLevel nodes zoom) bush) initialState