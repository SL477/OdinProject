import { add, subtract, divide, multiply } from './calculator.js';

test('Add', () => {
    expect(add(1, 2)).toBe(3);
});

test('Subtract', () => {
    expect(subtract(1, 2)).toBe(-1);
});

test('Divide', () => {
    expect(divide(1, 2)).toBe(0.5);
});

test('Multiply', () => {
    expect(multiply(2, 3)).toBe(6);
});
