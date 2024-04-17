/** Calculate the result
 * @param {('add'|'subtract'|'multiply'|'divide')} operator
 * @param {number} num1
 * @param {number} num2
 * @returns {number}
 */
function operate(operator, num1, num2) {
    switch (operator) {
        case 'add':
            return num1 + num2;
        case 'subtract':
            return num1 - num2;
        case 'multiply':
            return num1 * num2;
        case 'divide':
            if (num2 === 0) {
                alert('Cannot divide by zero');
                return 0;
            } else {
                return num1 / num2;
            }
    }
}
