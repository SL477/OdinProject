import { Book } from './book.mjs';

const myLibrary = [];
const libraryUL = document.getElementById('library');
const openNewBookBtn = document.getElementById('openNewBook');
const newBookDia = document.getElementById('newBook');
const newBookCloseBtn = document.getElementById('newBookClose');
const newBookForm = document.getElementById('newBookForm');

/** take params, create a book then store it in the array
 * @param {string} title
 * @param {string} author
 * @param {number} pages
 * @param {boolean} read
 */
function addBookToLibrary(title, author, pages, read) {
    myLibrary.push(new Book(title, author, pages, read));
}

function displayLibrary() {
    if (libraryUL) {
        libraryUL.innerHTML = '';
        for (const item of myLibrary) {
            const libraryLI = document.createElement('li');
            libraryLI.textContent = item.info();
            libraryUL.appendChild(libraryLI);
        }
    }
}

function main() {
    addBookToLibrary('The Hobbit', 'J.R.R. Tolkien', 295, false);
    displayLibrary();

    if (openNewBookBtn && newBookDia && newBookCloseBtn) {
        openNewBookBtn.addEventListener('click', () => newBookDia.showModal());
        newBookCloseBtn.addEventListener('click', () => newBookDia.close());
    }

    if (newBookForm) {
        newBookForm.addEventListener('submit', (ev) => {
            const formData = Object.fromEntries(new FormData(ev.target));
            // console.log('formData', formData);
            addBookToLibrary(
                formData.title,
                formData.author,
                formData.pages,
                formData.read
            );
            displayLibrary();
            ev.target.reset();
        });
    }
}

main();
