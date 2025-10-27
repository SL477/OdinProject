const battleshipContainer = document.getElementById('battleshipContainer');
const msg = document.getElementById('msg');
const MAX = 9;
import { Player } from './player.js';
import { fleet, directions } from './gameboard.js';

let humanPlayer;
let isWin = false;

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
        let rowCounter = 0;
        for (const row of player.board.board) {
            const tr = document.createElement('tr');
            let cellCounter = 0;
            for (const cell of row) {
                const td = document.createElement('td');
                if (cell) {
                    td.className = 'ship';
                }
                td.setAttribute('data-y', rowCounter.toString());
                td.setAttribute('data-x', cellCounter.toString());
                tr.appendChild(td);
                cellCounter++;
            }
            tbody.appendChild(tr);
            rowCounter++;
        }
    } else {
        for (let i = 0; i < 10; i++) {
            const tr = document.createElement('tr');
            for (let j = 0; j < 10; j++) {
                const td = document.createElement('td');
                td.setAttribute('data-y', i.toString());
                td.setAttribute('data-x', j.toString());
                td.addEventListener(
                    'click',
                    (ev) => {
                        if (!isWin) {
                            const y = Number.parseInt(
                                ev.target.getAttribute('data-y')
                            );
                            const x = Number.parseInt(
                                ev.target.getAttribute('data-x')
                            );
                            const attackResult = player.board.receiveAttack([
                                x,
                                y,
                            ]);
                            // console.log('attack', ev.target, y, x, attackResult);
                            if (attackResult === 'HIT') {
                                ev.target.className = 'hit';
                                ev.target.textContent = 'X';
                            } else {
                                ev.target.className = 'miss';
                                ev.target.textContent = 'M';
                            }
                            if (player.board.allSunk()) {
                                isWin = true;
                                msg.textContent = 'You Win!';
                            }

                            if (!isWin) {
                                // send attack to human player
                                // need to find a cell with no text in it
                                const emptyCells = getEmptyCells();
                                const moveNo = Math.floor(
                                    Math.random() * emptyCells.length
                                );
                                const playerAttackResult =
                                    humanPlayer.board.receiveAttack(
                                        emptyCells[moveNo]
                                    );

                                const humanBoard =
                                    document.getElementById('playerBoard');
                                const humanCell = humanBoard.querySelector(
                                    `[data-x='${emptyCells[moveNo][1]}'][data-y='${emptyCells[moveNo][0]}']`
                                );

                                if (playerAttackResult === 'HIT') {
                                    humanCell.className = 'hit';
                                    humanCell.textContent = 'X';
                                } else {
                                    humanCell.className = 'miss';
                                    humanCell.textContent = 'M';
                                }

                                if (humanPlayer.board.allSunk()) {
                                    isWin = true;
                                    msg.textContent = 'You Lost!';
                                }
                            }
                        }
                    },
                    { once: true }
                );
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

/**
 * Get all of the empty cells
 * @returns {Array}
 */
function getEmptyCells() {
    const emptyCells = [];
    let rowCounter = 0;
    for (const row of humanPlayer.board.board) {
        let cellCounter = 0;
        for (const cell of row) {
            if (!cell || (cell instanceof Array && !cell[1])) {
                emptyCells.push([rowCounter, cellCounter]);
            }
            cellCounter++;
        }
        rowCounter++;
    }
    return emptyCells;
}

function main() {
    if (battleshipContainer) {
        humanPlayer = new Player(0);
        const opponent = new Player(1);
        randomShipPlacement(humanPlayer);
        randomShipPlacement(opponent);
        drawBoard(humanPlayer);
        drawBoard(opponent);
    }
}
main();
