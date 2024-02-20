
import * as DeckGL from 'deck.gl';

export const enableLogging = function () {
    DeckGL.log.enable()
    DeckGL.log.level = 2
}