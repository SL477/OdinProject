import { Book } from './book.mjs';

const myLibrary = [];
const libraryUL = document.getElementById('library');

/** take params, create a book then store it in the array
 * @param {string} title
 * @param {string} author
 * @param {number} pages
 * @param {boolean} read
 */
function addBookToLibrary(title, author, pages, read) {
    myLibrary.push(new Book(title, author, pages, read));
}

function main() {
    addBookToLibrary('The Hobbit', 'J.R.R. Tolkien', 295, false);
    if (myLibrary) {
        for (const item of myLibrary) {
            const libraryLI = document.createElement('li');
            libraryLI.textContent = item.info();
            libraryUL.appendChild(libraryLI);
        }
    }
}

main();
