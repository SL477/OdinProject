const sf = require('./stringFunctions.js');

test('capitalise', () => {
    expect(sf[0]('test')).toBe('Test');
});

test('reverse', () => {
    expect(sf[1]('test')).toBe('tset');
});
