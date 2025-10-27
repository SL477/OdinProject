import { Ship } from './ship.js';

test('Ship hit', () => {
    const ship = new Ship(1, 0);
    ship.hit();
    expect(ship.numberHits).toBe(1);
});

test('Ship isSunk', () => {
    const ship1 = new Ship(1, 0);
    expect(ship1.isSunk()).toBe(false);
    ship1.hit();
    expect(ship1.isSunk()).toBe(true);
});
