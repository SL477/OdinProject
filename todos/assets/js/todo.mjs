export default class TODO {
    /**
     * Create a TODO
     * @param {string} title
     * @param {string} description
     * @param {date} dueDate
     * @param {number} priority
     * @param {boolean} isDone
     */
    constructor(title, description, dueDate, priority, isDone) {
        this.title = title;
        this.description = description;
        this.dueDate = dueDate;
        this.priority = priority;
        this.isDone = isDone;
    }
}
