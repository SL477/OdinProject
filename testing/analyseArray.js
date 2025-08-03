/**
 *function that takes an array of numbers and returns an object with the following properties: average, min, max, and length
 * @param {number[]} arr
 * @returns {{average: number, min: number, max: number, length: number}}
 */
function analyzeArray(arr) {
    const ret = {
        average: 0,
        min: undefined,
        max: undefined,
        length: arr.length,
    };
    let sum = 0;
    for (const num of arr) {
        sum += num;
        if (!ret.min || num < ret.min) {
            ret.min = num;
        }
        if (!ret.max || num > ret.max) {
            ret.max = num;
        }
    }
    ret.average = sum / ret.length;
    return ret;
}

module.exports = analyzeArray;
