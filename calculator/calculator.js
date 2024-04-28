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
        runEquals();
        selectedOperator = operator;
    }
}

/**
 * This is what happens when the equals button is pressed
 */
function runEquals() {
    const num1Number = parseFloat(num1.textContent);
    const num2Number = parseFloat(num2.textContent);
    const resultNumber = operate(selectedOperator, num1Number, num2Number);
    result.textContent = resultNumber.toString();
    isNum1 = false;
    selectedOperator = undefined;
    num2.textContent = '0';
    num1.textContent = resultNumber.toString();
    return resultNumber;
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
    let currentNum = (isNum1 ? num1 : num2).textContent;
    if (currentNum === '0') {
        currentNum = num.toString();
    } else {
        currentNum += num.toString();
    }
    (isNum1 ? num1 : num2).textContent = currentNum;
}

/**
 * Undo the last bit of text
 */
function runBackspace() {
    let currentNum = (isNum1 ? num1 : num2).textContent;
    if (currentNum !== '0' && currentNum.length > 1) {
        if (currentNum === '-0') {
            currentNum = '0';
        } else {
            currentNum = currentNum.substring(0, currentNum.length - 1);
        }
    } else {
        currentNum = '0';
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
 * Clear everything
 */
function runAllClear() {
    selectedOperator = undefined;
    isNum1 = true;
    result.textContent = '0';
    num1.textContent = '0';
    num2.textContent = '0';
}

/**
 * Keyboard support for calculator
 * @param {KeyboardEvent} ev
 */
function keyboardEntry(ev) {
    const keyMap = {
        '/': 'divide',
        x: 'multiply',
        '*': 'multiply',
        d: 'divide',
        '-': 'subtract',
        s: 'subtract',
        '+': 'add',
        a: 'add',
        '=': 'equals',
        e: 'equals',
        Enter: 'equals',
        Delete: 'allClear',
        '.': 'dot',
    };
    if (/[0-9]/.test(ev.key)) {
        const btn = document.getElementById(`btn${ev.key}`);
        if (btn) {
            btn.click();
        }
    } else if (Object.prototype.hasOwnProperty.call(keyMap, ev.key)) {
        const btn = document.getElementById(keyMap[ev.key]);
        if (btn) {
            btn.click();
        }
    } else if (ev.key === 'Backspace') {
        runBackspace();
    }
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

    const equals = document.getElementById('equals');
    if (equals) {
        equals.addEventListener('click', runEquals);
    }

    const allClear = document.getElementById('allClear');
    if (allClear) {
        allClear.addEventListener('click', runAllClear);
    }

    const calculator = document.getElementById('calculatorContainer');
    if (calculator) {
        calculator.addEventListener('keyup', keyboardEntry);
    }
}

startUp();
