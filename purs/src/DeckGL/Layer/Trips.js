import * as DeckGL from 'deck.gl';

export const makeTripsLayer = function (props) {
    return new DeckGL.TripsLayer(props);
};

export const defaultTripsProps = DeckGL.TripsLayer.defaultProps;