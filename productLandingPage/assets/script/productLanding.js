function setCurrentYear() {
    const currentYear = document.getElementById('currentYear');
    const d = new Date();
    currentYear.textContent = d.getFullYear();
}
setCurrentYear();
