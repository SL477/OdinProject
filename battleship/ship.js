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
        // console.log(
        //     'ship is sunk',
        //     this.numberHits,
        //     this.length,
        //     this.numberHits >= this.length
        // );
        return this.numberHits >= this.length;
    }
}
