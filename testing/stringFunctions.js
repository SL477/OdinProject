/**function that takes a string and returns it with the first character capitalized
 * @param {string} str
 * @returns {string}
 */
function capitalize(str) {
    return str.substring(0, 1).toUpperCase() + str.substring(1);
}

module.exports = capitalize;
