import TODO from './todo.mjs';
export default class Project {
    /**
     * Create a project
     * @param {string} code
     * @param {string} notes
     * @param {TODO[]} todos
     */
    constructor(code, notes, todos) {
        this.code = code;
        this.notes = notes;
        this.todos = todos;
    }
}
