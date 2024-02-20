import * as DeckGL from 'deck.gl';

export const makePathLayer = function (props) {
    console.log('makePathLayer', props);
    return new DeckGL.PathLayer(props);
};

export const defaultPathProps = DeckGL.PathLayer.defaultProps;