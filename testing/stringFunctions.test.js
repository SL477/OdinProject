const sf = require('./stringFunctions.js');

test('capitalise', () => {
    expect(sf('test')).toBe('Test');
});
