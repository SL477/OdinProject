import { GameBoard, ShipType, directions } from './gameboard';

test('PlaceShip ok', () => {
    const board = new GameBoard();
    expect(
        board.placeShip(new ShipType('Submarine', 1), [0, 0], directions.DOWN)
    ).toBe(true);
});

test('PlaceShip on another ship', () => {
    const board = new GameBoard();
    expect(
        board.placeShip(new ShipType('Aircraft', 5), [0, 0], directions.DOWN)
    ).toBe(true);
    expect(
        board.placeShip(new ShipType('Submarine', 1), [0, 0], directions.DOWN)
    ).toBe(false);
});

test('PlaceShip outside board', () => {
    const board = new GameBoard();
    expect(
        board.placeShip(new ShipType('Aircraft', 5), [0, 0], directions.UP)
    ).toBe(false);
});
