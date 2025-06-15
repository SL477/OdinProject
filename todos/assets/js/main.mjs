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
const currentProjectSel = document.getElementById('currentProjectSel');
const saveBtn = document.getElementById('saveBtn');
let projects = [];

if (todoAddBtn && todoForm && todoCloseBtn) {
    todoAddBtn.addEventListener('click', () => todoForm.showModal());
    todoCloseBtn.addEventListener('click', () => todoForm.close());
}

if (projectAddBtn && projectForm && projectCloseBtn) {
    projectAddBtn.addEventListener('click', () => projectForm.showModal());
    projectCloseBtn.addEventListener('click', () => projectForm.close());
}

if (saveBtn) {
    saveBtn.addEventListener('click', () => {
        localStorage.setItem('todoProjects', JSON.stringify(projects));
        console.log('saved');
    });
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
        let isNew = false;
        const projectData = new FormData(projectFormFm);
        let id = projectData.get('id');
        if (!id || id === '') {
            id = crypto.randomUUID();
            isNew = true;
        }
        const newProject = new Project(
            projectData.get('code'),
            projectData.get('notes'),
            [],
            id
        );
        console.log(newProject);
        if (isNew) {
            projects.push(newProject);
        } else {
            const projectIdx = projects.indexOf((p) => p.id === id);
            newProject.todos = projects[projectIdx].todos;
            projects[projectIdx] = newProject;
        }
        displayCurrentProjects();
    });
}

/**
 * Fill the current project with the codes of the projects
 */
function displayCurrentProjects() {
    if (currentProjectSel) {
        currentProjectSel.innerHTML = '';
        for (const prj of projects) {
            const opt = document.createElement('option');
            opt.value = prj.id;
            opt.text = prj.code;
            currentProjectSel.appendChild(opt);
        }
    }
}
//#endregion

//#region On Load
/**
 * Load projects
 */
function loadProjects() {
    const storedProjects = localStorage.getItem('todoProjects');
    if (storedProjects) {
        projects = JSON.parse(storedProjects);
    } else {
        projects = [new Project('Default', '', [])];
    }
    console.log(projects);
    displayCurrentProjects();
}
loadProjects();
//#endregion
