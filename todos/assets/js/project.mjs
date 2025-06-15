import TODO from './todo.mjs';
export default class Project {
    /**
     * Create a project
     * @param {string} code
     * @param {string} notes
     * @param {TODO[]} todos
     * @param {string} id
     * @param {string[]} statuses
     */
    constructor(code, notes, todos, id, statuses) {
        this.code = code;
        this.notes = notes;
        this.todos = todos;
        this.id = id;
        this.statuses = statuses;
    }
}
