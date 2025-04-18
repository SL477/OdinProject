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

/**
 * Remove a book
 * @param {MouseEvent} ev
 */
function RemoveBook(ev) {
    const removeId = ev.currentTarget.parentElement.getAttribute('data-id');
    const removeIdx = myLibrary.findIndex((i) => i.id === removeId);
    console.log(removeId, removeIdx);
    myLibrary.splice(removeIdx, 1);
    displayLibrary();
}

/**Display the books in the library */
function displayLibrary() {
    if (libraryUL) {
        libraryUL.innerHTML = '';
        for (const item of myLibrary) {
            const libraryLI = document.createElement('li');
            libraryLI.textContent = item.info();
            libraryLI.setAttribute('data-id', item.id);
            const removeBookBtn = document.createElement('button');
            removeBookBtn.type = 'button';
            removeBookBtn.textContent = 'Remove';
            removeBookBtn.classList = 'btn btn-danger';
            removeBookBtn.addEventListener('click', RemoveBook);
            libraryLI.appendChild(removeBookBtn);
            libraryUL.appendChild(libraryLI);
        }
    }
}

/**Display the library and add the event listeners */
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
