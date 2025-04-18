export class Book {
    /**
     * Book Constructor
     * @param {string} title
     * @param {string} author
     * @param {number} pages
     * @param {boolean} read
     */
    constructor(title, author, pages, read) {
        this.title = title;
        this.author = author;
        this.pages = pages;
        this.read = read;
        this.id = crypto.randomUUID();
    }

    /**
     * return info about the book
     * @returns {string}
     */
    info() {
        return `${this.title} by ${this.author}, ${this.pages} pages, ${this.read ? 'read' : 'not read yet'}`;
    }

    toggleRead() {
        this.read = !this.read;
    }
}
