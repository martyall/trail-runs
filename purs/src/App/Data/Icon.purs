module App.Data.Icon where

import Prelude

import Data.Argonaut as A
import Data.Int (toNumber)

-- | The icon's name is based on the size of the cluster.
getIconName :: Int -> String
getIconName size
  | size == 0 = ""
  | size < 10 = "marker-" <> show size
  | size < 100 = "marker-" <> show (size / 10) <> "0"
  | otherwise = "marker-100"

-- | Scale the icon according to the size of the cluster.
getIconSize :: Int -> Number
getIconSize size = (min 100.0 (toNumber size) / 50.0) + 0.5

-- | The base icon size.
iconSize :: Number
iconSize = 60.0

-- | IconMapping entry
newtype IconEntry =
  IconEntry
    { label :: String
    , x :: Int
    , y :: Int
    , width :: Int
    , height :: Int
    , anchorY :: Int
    }

instance decodeJsonIconEntry :: A.DecodeJson IconEntry where
  decodeJson json = do
    obj <- A.decodeJson json
    label <- obj A..: "label"
    x <- obj A..: "x"
    y <- obj A..: "y"
    width <- obj A..: "width"
    height <- obj A..: "height"
    anchorY <- obj A..: "anchorY"
    pure $ IconEntry { label, x, y, width, height, anchorY }

