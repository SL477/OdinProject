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
const kanbanBoard = document.getElementById('kanbanBoard');
let projects = [];
let currentProject = '';
const defaultStatuses = ['TODO', 'In Progress', 'Done'];

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

if (currentProjectSel) {
    currentProjectSel.addEventListener('change', (e) => {
        const val = e.target.value;
        console.log('currentProjectSel val', val);
        setCurrentProject(val);
        displayKanban();
    });
}

//#region TODO Form
if (todoFormFm) {
    todoFormFm.addEventListener('submit', () => {
        let isNew = false;
        const todoData = new FormData(todoFormFm);
        // console.log(Object.fromEntries(todoData));
        let id = todoData.get('id');
        if (!id || id === '') {
            id = crypto.randomUUID();
            isNew = true;
        }
        const newTodo = new TODO(
            todoData.get('title'),
            todoData.get('description'),
            todoData.get('dueDate'),
            todoData.get('priority'),
            todoData.get('status'),
            id
        );
        // console.log(newTodo);
        const curProject = getCurrentProject();
        if (curProject) {
            if (isNew) {
                curProject.todos.push(newTodo);
            } else {
                const getTodoIdx = curProject.todos.findIndex(
                    (t) => t.id === id
                );
                if (getTodoIdx > -1) {
                    curProject.todos[getTodoIdx] = newTodo;
                } else {
                    curProject.todos.push(newTodo);
                }
            }
            console.log(curProject);
        }
        displayKanban();
        todoFormFm.reset();
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
            id,
            []
        );
        console.log(newProject);
        if (isNew) {
            newProject.statuses = defaultStatuses;
            projects.push(newProject);
        } else {
            const projectIdx = projects.indexOf((p) => p.id === id);
            newProject.todos = projects[projectIdx].todos;
            newProject.statuses = projects[projectIdx].statuses;
            projects[projectIdx] = newProject;
        }
        displayCurrentProjects();
        projectFormFm.reset();
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

/**
 * Get the current project
 * @returns {Project|null}
 */
function getCurrentProject() {
    const projectIdx = projects.findIndex((p) => p.id === currentProject);
    if (projectIdx > -1) {
        return projects[projectIdx];
    }
    return null;
}

function updateTodoStatuses() {
    const todoStatusSel = document.getElementById('todoStatusSel');
    const curProject = getCurrentProject();
    if (curProject && todoStatusSel) {
        todoStatusSel.innerHTML = '';
        for (const stat of curProject.statuses) {
            const opt = document.createElement('option');
            opt.value = stat;
            opt.text = stat;
            todoStatusSel.appendChild(opt);
        }
    }
}

/**
 * Set the current project
 * @param {string} projectID
 */
function setCurrentProject(projectID) {
    currentProject = projectID;
    updateTodoStatuses();
}
//#endregion

//#region Display Kanban
function displayKanban() {
    const curProject = getCurrentProject();
    if (curProject && kanbanBoard) {
        kanbanBoard.innerHTML = '';
        for (const stat of curProject.statuses) {
            const statDiv = document.createElement('div');
            const statTitle = document.createElement('h2');
            statTitle.textContent = stat;
            statDiv.appendChild(statTitle);
            statDiv.className = 'kanbanColumn';

            // Tasks
            const statTasks = curProject.todos.filter((t) => t.status === stat);
            statTasks.sort((t1, t2) => t1.priority >= t2.priority);
            for (const task of statTasks) {
                const taskDiv = document.createElement('div');
                taskDiv.className = 'todoTask';
                taskDiv.setAttribute('data-id', task.id);
                const taskTitle = document.createElement('h3');
                taskTitle.textContent = task.title;
                taskDiv.appendChild(taskTitle);
                const taskDesc = document.createElement('p');
                taskDesc.textContent = task.description;
                taskDiv.appendChild(taskDesc);
                const taskDue = document.createElement('p');
                taskDue.innerHTML = `Due: <time datetime="${task.dueDate}">${new Date(task.dueDate).toLocaleDateString()}</time>`;
                taskDiv.appendChild(taskDue);

                statDiv.appendChild(taskDiv);
            }

            kanbanBoard.appendChild(statDiv);
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
        projects = [
            new Project(
                'Default',
                '',
                [],
                crypto.randomUUID(),
                defaultStatuses
            ),
        ];
    }
    console.log(projects);
    displayCurrentProjects();
    setCurrentProject(projects[0].id);
    displayKanban();
}
loadProjects();
//#endregion
