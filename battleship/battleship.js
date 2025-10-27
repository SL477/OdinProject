const battleshipContainer = document.getElementById('battleshipContainer');

function setupBoard() {
    const playerTbl = document.createElement('table');
    playerTbl.className = 'board';

    const thead = document.createElement('thead');
    thead.innerHTML = '<tr><th colspan="10">Your Board</th></tr>';
    playerTbl.appendChild(thead);

    const tbody = document.createElement('tbody');
    for (let i = 0; i < 10; i++) {
        const tr = document.createElement('tr');
        for (let j = 0; j < 10; j++) {
            const td = document.createElement('td');
            tr.appendChild(td);
        }
        tbody.appendChild(tr);
    }
    playerTbl.appendChild(tbody);
    battleshipContainer.appendChild(playerTbl);
}

function main() {
    if (battleshipContainer) {
        setupBoard();
    }
}
main();
