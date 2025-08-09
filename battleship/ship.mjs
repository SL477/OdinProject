export default class Ship {
    /**
     * Ship class
     * @param {number} length
     * @param {number} numberHits
     * @param {boolean} isSunk
     */
    constructor(length, numberHits, isSunk) {
        self.length = length;
        self.numberHits = numberHits;
        self.isSunk = isSunk;
    }

    /**
     * Hit the ship
     */
    hit() {
        self.numberHits++;
    }

    /**
     * Whether or not the ship is sunk
     * @returns {boolean}
     */
    isSunk() {
        return self.numberHits >= self.length;
    }
}
