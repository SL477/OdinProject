import TODO from './todo.mjs';
import Project from './project.mjs';

const todoAddBtn = document.getElementById('todoAddBtn');
const todoForm = document.getElementById('todoForm');
const todoCloseBtn = document.getElementById('todoCloseBtn');
const todoFormFm = document.getElementById('todoFormFm');
const projectAddBtn = document.getElementById('projectAddBtn');
const projectForm = document.getElementById('projectForm');
const projectCloseBtn = document.getElementById('projectCloseBtn');
const projectFormFm = document.getElementById('projectFormFm');

if (todoAddBtn && todoForm && todoCloseBtn) {
    todoAddBtn.addEventListener('click', () => todoForm.showModal());
    todoCloseBtn.addEventListener('click', () => todoForm.close());
}

if (projectAddBtn && projectForm && projectCloseBtn) {
    projectAddBtn.addEventListener('click', () => projectForm.showModal());
    projectCloseBtn.addEventListener('click', () => projectForm.close());
}

//#region TODO Form
if (todoFormFm) {
    todoFormFm.addEventListener('submit', () => {
        const todoData = new FormData(todoFormFm);
        // console.log(Object.fromEntries(todoData));
        const newTodo = new TODO(
            todoData.get('title'),
            todoData.get('description'),
            todoData.get('dueDate'),
            todoData.get('priority'),
            todoData.get('isDone')
        );
        console.log(newTodo);
    });
}
//#endregion

//#region Project Form
if (projectFormFm) {
    projectFormFm.addEventListener('submit', () => {
        const projectData = new FormData(projectFormFm);
        const newProject = new Project(
            projectData.get('code'),
            projectData.get('notes'),
            []
        );
        console.log(newProject);
    });
}
//#endregion
