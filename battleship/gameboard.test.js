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

test('ReceiveAttack Sunk', () => {
    const board = new GameBoard();
    board.placeShip(new ShipType('Submarine', 1), [0, 0], directions.DOWN);
    expect(board.receiveAttack([0, 0])).toBe('SUNK');
});

test('ReceiveAttack Miss', () => {
    const board = new GameBoard();
    board.placeShip(new ShipType('Submarine', 1), [0, 0], directions.DOWN);
    expect(board.receiveAttack([0, 1])).toBe('MISS');
});

test('AllSunk true', () => {
    const board = new GameBoard();
    board.placeShip(new ShipType('Submarine', 1), [0, 0], directions.DOWN);
    board.receiveAttack([0, 0]);
    expect(board.allSunk()).toBe(true);
});

test('AllSunk false', () => {
    const board = new GameBoard();
    board.placeShip(new ShipType('Submarine', 1), [0, 0], directions.DOWN);
    expect(board.allSunk()).toBe(false);
});
