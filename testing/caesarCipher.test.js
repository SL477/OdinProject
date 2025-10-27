import { caesarCipher } from './caesarCipher.js';

test('Wrapping', () => {
    expect(caesarCipher('xyz', 3)).toBe('abc');
});

test('case preservation', () => {
    expect(caesarCipher('HeLLo', 3)).toBe('KhOOr');
});

test('punctuation', () => {
    expect(caesarCipher('Hello, World!', 3)).toBe('Khoor, Zruog!');
});
