import { GameBoard } from './gameboard';
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
