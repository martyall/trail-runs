import * as DeckGL from 'deck.gl';

export const makeTerrainLayer = function (props) {
    return new DeckGL.TerrainLayer(props);
};

export const defaultTerrainProps = DeckGL.TerrainLayer.defaultProps;