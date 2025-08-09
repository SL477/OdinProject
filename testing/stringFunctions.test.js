import { capitalize, reverseString } from './stringFunctions.js';

test('capitalise', () => {
    expect(capitalize('test')).toBe('Test');
});

test('reverse', () => {
    expect(reverseString('test')).toBe('tset');
});
