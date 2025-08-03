const calc = require('./calculator.js');

test('Add', () => {
    expect(calc.add(1, 2)).toBe(3);
});

test('Subtract', () => {
    expect(calc.subtract(1, 2)).toBe(-1);
});

test('Divide', () => {
    expect(calc.divide(1, 2)).toBe(0.5);
});

test('Multiply', () => {
    expect(calc.multiply(2, 3)).toBe(6);
});
