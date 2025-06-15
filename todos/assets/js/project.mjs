import TODO from './todo.mjs';
export default class Project {
    /**
     * Create a project
     * @param {string} code
     * @param {string} notes
     * @param {TODO[]} todos
     * @param {string} id
     */
    constructor(code, notes, todos, id) {
        this.code = code;
        this.notes = notes;
        this.todos = todos;
        this.id = id;
    }
}
