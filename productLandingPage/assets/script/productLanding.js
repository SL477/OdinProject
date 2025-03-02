/**
 * Set the current year on the current year node
 * @returns {null}
 */
function setCurrentYear() {
    const currentYear = document.getElementById('currentYear');
    const d = new Date();
    currentYear.textContent = d.getFullYear();
}
setCurrentYear();

const dialog = document.querySelector('dialog');
const closeButton = document.querySelector('dialog button');
const openButton = document.getElementById('infoModalButton');
const infoModalFirstBtn = document.getElementById('infoModalFirst');

openButton.addEventListener('click', () => dialog.showModal());
closeButton.addEventListener('click', () => dialog.close());
infoModalFirstBtn.addEventListener('click', () => dialog.showModal());
