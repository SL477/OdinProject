export class Ship {
    /**
     * Ship class
     * @param {number} length
     * @param {number} numberHits
     */
    constructor(length, numberHits) {
        this.length = length;
        this.numberHits = numberHits;
    }

    /**
     * Hit the ship
     */
    hit() {
        this.numberHits++;
    }

    /**
     * Whether or not the ship is sunk
     * @returns {boolean}
     */
    isSunk() {
        return this.numberHits >= this.length;
    }
}
