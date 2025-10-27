import { GameBoard } from './gameboard.js';
export const playerType = {
    AI: 0,
    Human: 1,
};

export class Player {
    /**
     * Create a player
     * @param {number} type
     */
    constructor(type) {
        this.type = type;
        this.board = new GameBoard();
    }
}
