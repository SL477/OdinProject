let isNum1 = true;
const num1 = document.getElementById('num1');
const num2 = document.getElementById('num2');

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

/**
 * Set the current number
 * @param {number} num
 */
function SetNumber(num) {
    console.log('SetNumber', num);
    if (isNum1) {
        if (num1.textContent === '0') {
            num1.textContent = num.toString();
        } else {
            num1.textContent += num.toString();
        }
    } else {
        num2.textContent += num.toString();
    }
}

/**
 * This is what happens when the decimal button is clicked
 */
function SetDot() {
    if (isNum1) {
        if (num1.textContent.indexOf('.') === -1) {
            num1.textContent += '.';
        }
    } else {
        if (num2.textContent.indexOf('.') === -1) {
            num2.textContent += '.';
        }
    }
}

function startUp() {
    for (let i = 0; i < 10; i++) {
        const btn = document.getElementById(`btn${i}`);
        if (btn) {
            btn.addEventListener('click', () => SetNumber(i));
        } else {
            console.log('cannot find ', `btn${i}`);
        }
    }

    const dot = document.getElementById('dot');
    if (dot) {
        dot.addEventListener('click', SetDot);
    }
}

startUp();
