const battleshipContainer = document.getElementById('battleshipContainer');
const MAX = 9;
import { Player } from './player.js';
import { fleet, directions } from './gameboard.js';

/**
 * Draw the board
 * @param {Player} player
 */
function drawBoard(player) {
    console.log(player);
    const playerTbl = document.createElement('table');
    playerTbl.className = 'board';
    playerTbl.id = player.type === 0 ? 'playerBoard' : 'opponentBoard';

    const thead = document.createElement('thead');
    thead.innerHTML = `<tr><th colspan="10">${player.type === 0 ? 'Your' : 'Opponent'} Board</th></tr>`;
    playerTbl.appendChild(thead);

    const tbody = document.createElement('tbody');
    if (player.type === 0) {
        for (const row of player.board.board) {
            const tr = document.createElement('tr');
            for (const cell of row) {
                const td = document.createElement('td');
                if (cell) {
                    td.className = 'ship';
                }
                tr.appendChild(td);
            }
            tbody.appendChild(tr);
        }
    } else {
        for (let i = 0; i < 10; i++) {
            const tr = document.createElement('tr');
            for (let j = 0; j < 10; j++) {
                const td = document.createElement('td');
                tr.appendChild(td);
            }
            tbody.appendChild(tr);
        }
    }

    playerTbl.appendChild(tbody);
    battleshipContainer.appendChild(playerTbl);
}

const randomDirection = () => {
    const rnd = Math.floor(Math.random() * 4);
    switch (rnd) {
        case 0:
            return directions.UP;
        case 1:
            return directions.DOWN;
        case 2:
            return directions.LEFT;
        default:
            return directions.RIGHT;
    }
};

/**
 * Place the ships randomly
 * @param {Player} player
 */
function randomShipPlacement(player) {
    for (const st of fleet) {
        let dir = randomDirection();
        let x = Math.floor(Math.random() * MAX);
        let y = Math.floor(Math.random() * MAX);
        while (!player.board.placeShip(st, [x, y], dir)) {
            dir = randomDirection();
            x = Math.floor(Math.random() * MAX);
            y = Math.floor(Math.random() * MAX);
        }
    }
}

function main() {
    if (battleshipContainer) {
        const player = new Player(0);
        const opponent = new Player(1);
        randomShipPlacement(player);
        randomShipPlacement(opponent);
        drawBoard(player);
        drawBoard(opponent);
    }
}
main();
