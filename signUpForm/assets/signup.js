/**
 * @param {HTMLInputElement} ev
 */
// eslint-disable-next-line no-unused-vars
function onChangeValidationMessage(ev) {
    ev.parentNode.querySelector('.validationMessage').textContent =
        ev.validationMessage;
}

const passwordInput = document.getElementById('password');
const passwordConfirmInput = document.getElementById('passwordConfirm');

// eslint-disable-next-line no-unused-vars
passwordInput.addEventListener('input', (_ev) => {
    passwordInput.setCustomValidity('');
    const validationMessageNode =
        passwordInput.parentNode.querySelector('.validationMessage');
    validationMessageNode.textContent = '';
    if (!passwordInput.validity.valid) {
        validationMessageNode.textContent = passwordInput.validationMessage;
        return;
    }

    // Check the confirm input
    if (passwordInput.value !== passwordConfirmInput.value) {
        passwordInput.setCustomValidity(
            'Password and Confirm Password do not match'
        );
        validationMessageNode.textContent = passwordInput.validationMessage;
    } else if (
        passwordConfirmInput.parentNode.querySelector('.validationMessage')
            .textContent
    ) {
        passwordConfirmInput.dispatchEvent(new Event('input'));
    }
});

// eslint-disable-next-line no-unused-vars
passwordConfirmInput.addEventListener('input', (_ev) => {
    passwordInput.setCustomValidity('');
    const validationMessageNode =
        passwordConfirmInput.parentNode.querySelector('.validationMessage');
    validationMessageNode.textContent = '';
    if (!passwordConfirmInput.validity.valid) {
        validationMessageNode.textContent =
            passwordConfirmInput.validationMessage;
        return;
    }

    // Check the confirm input
    if (passwordInput.value !== passwordConfirmInput.value) {
        passwordConfirmInput.setCustomValidity(
            'Password and Confirm Password do not match'
        );
        validationMessageNode.textContent =
            passwordConfirmInput.validationMessage;
    } else if (
        passwordInput.parentNode.querySelector('.validationMessage').textContent
    ) {
        passwordInput.dispatchEvent(new Event('input'));
    }
});
