import { Ship } from './ship.js';

export const directions = {
    UP: 0,
    DOWN: 1,
    LEFT: 2,
    RIGHT: 3,
};

/**
 * ShipTypes
 */
export class ShipType {
    /**
     * Create a type of ship
     * @param {string} type
     * @param {number} size
     */
    constructor(type, size) {
        this.type = type;
        this.size = size;
    }
}

export const fleet = [
    new ShipType('Aircraft', 5),
    new ShipType('Battleship', 4),
    new ShipType('Cruiser', 3),
    new ShipType('Destroyer', 2),
    new ShipType('Destroyer', 2),
    new ShipType('Submarine', 1),
    new ShipType('Submarine', 1),
];

export class GameBoard {
    constructor() {
        this.board = [...Array(10)].map((e) => Array(10));
    }

    /**
     * Place a ship on the board if it is valid
     * @param {ShipType} shipType
     * @param {number[2]} coordinates
     * @param {number} direction
     * @returns {boolean}
     */
    placeShip(shipType, coordinates, direction) {
        // build the coordinates
        const coordinatesArray = [];
        for (let i = 0; i < shipType.size; i++) {
            const tmpCoordinate = [...coordinates];
            if (direction === directions.DOWN) {
                tmpCoordinate[1] += i;
            } else if (direction === directions.UP) {
                tmpCoordinate[1] -= i;
            } else if (direction === directions.LEFT) {
                tmpCoordinate[0] -= i;
            } else if (direction === directions.RIGHT) {
                tmpCoordinate[0] += i;
            }
            coordinatesArray.push(tmpCoordinate);
        }

        // check the coordinates are valid
        for (const coordinate of coordinatesArray) {
            if (!this._validCoordinates(coordinate)) {
                return false;
            }
            if (this.board[coordinate[0]][coordinate[1]]) {
                return false;
            }
        }

        // place the ship
        const ship = new Ship(shipType.size, 0);
        for (const coordinate of coordinatesArray) {
            this.board[coordinate[0]][coordinate[1]] = [ship, false];
        }
        return true;
    }

    /**
     * Receive an attack
     * @param {number[2]} coordinate
     * @returns {string}
     */
    receiveAttack(coordinate) {
        if (!this._validCoordinates(coordinate)) {
            return false;
        }
        const item = this.board[coordinate[0]][coordinate[1]];
        if (item instanceof Array) {
            item[1] = true;
            item[0].hit();
            if (item[0].isSunk()) {
                return 'SUNK';
            } else {
                return 'HIT';
            }
        } else {
            this.board[coordinate[0]][coordinate[1]] = true;
            return 'MISS';
        }
    }

    /**
     * Check if all ships are sunk
     * @returns {Boolean}
     */
    allSunk() {
        // for (let i = 0; i < 10; i++) {
        //     for (let j = 0; j < 10; j++) {
        //         const item = this.board[i][j];
        //         if (item instanceof Array) {
        //             if (!item[0].isSunk()) {
        //                 return false;
        //             }
        //         }
        //     }
        // }
        // for (const ship of this.board.filter((c) => c instanceof Array)) {
        //     console.log(ship);
        //     if (!ship[0].isSunk()) {
        //         console.log('sunk', false);
        //         return false;
        //     }
        // }

        // console.log(
        //     'flat',
        //     this.board
        //         .flat(1)
        //         .filter((c) => c instanceof Array)
        //         .filter((s) => !s[0].isSunk()).length
        // );
        // for (const ship of this.board
        //     .flat(1)
        //     .filter((c) => c instanceof Array)) {
        //     if (!ship[0].isSunk()) {
        //         // console.log('sunk', false);
        //         return false;
        //     }
        // }
        // console.log('sunk', true);
        const floatingShips = this.board
            .flat(1)
            .filter((c) => c instanceof Array && !c[0].isSunk()).length;
        // console.log('floating ships', floatingShips);
        return floatingShips <= 0;
        // return true;
    }

    /**
     * check the coordinates are valid
     * @param {number[2]} coordinates
     * @returns {boolean}
     */
    _validCoordinates(coordinates) {
        if (
            coordinates[0] < 0 ||
            coordinates[0] > 9 ||
            coordinates[1] < 0 ||
            coordinates[1] > 9
        ) {
            return false;
        }
        return true;
    }
}
