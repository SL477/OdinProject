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
