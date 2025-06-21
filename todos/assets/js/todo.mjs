export default class TODO {
    /**
     * Create a TODO
     * @param {string} title
     * @param {string} description
     * @param {date} dueDate
     * @param {number} priority
     * @param {string} status
     * @param {string} id
     */
    constructor(title, description, dueDate, priority, status, id) {
        this.title = title;
        this.description = description;
        this.dueDate = dueDate;
        this.priority = priority;
        this.status = status;
        this.id = id;
    }
}
