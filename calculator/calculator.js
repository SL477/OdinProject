let isNum1 = true;
const num1 = document.getElementById('num1');
const num2 = document.getElementById('num2');
const result = document.getElementById('result');
let selectedOperator;

/**
 * Run the operation
 * @param {('add'|'subtract'|'multiply'|'divide')} operator
 */
function runOperator(operator) {
    if (!selectedOperator) {
        selectedOperator = operator;
        isNum1 = false;
    } else {
        const num1Number = parseFloat(num1.textContent);
        const num2Number = parseFloat(num2.textContent);
        const resultNumber = operate(selectedOperator, num1Number, num2Number);
        num1.textContent = resultNumber.toString();
        result.textContent = resultNumber.toString();
        isNum1 = false;
        selectedOperator = operator;
        num2.textContent = '0';
    }
}

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
    // if (isNum1) {
    //     if (num1.textContent === '0') {
    //         num1.textContent = num.toString();
    //     } else {
    //         num1.textContent += num.toString();
    //     }
    // } else {
    //     num2.textContent += num.toString();
    // }

    let currentNum = (isNum1 ? num1 : num2).textContent;
    if (currentNum === '0') {
        currentNum = num.toString();
    } else {
        currentNum += num.toString();
    }
    (isNum1 ? num1 : num2).textContent = currentNum;
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

/**
 * Make the number negative
 */
function setPlusMinus() {
    let num = (isNum1 ? num1 : num2).textContent;
    if (num.startsWith('-')) {
        num = num.substring(1);
    } else {
        num = '-' + num;
    }
    (isNum1 ? num1 : num2).textContent = num;
}

/**
 * Add the event listeners to the buttons
 */
function startUp() {
    for (let i = 0; i < 10; i++) {
        const btn = document.getElementById(`btn${i}`);
        if (btn) {
            btn.addEventListener('click', () => SetNumber(i));
        }
    }

    const dot = document.getElementById('dot');
    if (dot) {
        dot.addEventListener('click', SetDot);
    }

    const plusMinus = document.getElementById('plusMinus');
    if (plusMinus) {
        plusMinus.addEventListener('click', setPlusMinus);
    }

    const operators = ['add', 'subtract', 'multiply', 'divide'];
    for (const op of operators) {
        const opBtn = document.getElementById(op);
        if (opBtn) {
            opBtn.addEventListener('click', () => runOperator(op));
        }
    }
}

startUp();
