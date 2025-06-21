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
const todoDeleteBtn = document.getElementById('todoDeleteBtn');
const curProjectNotes = document.getElementById('curProjectNotes');
const projectStatusesBtn = document.getElementById('projectStatusesBtn');
const projectStatusForm = document.getElementById('projectStatusForm');
const projectStatusCloseBtn = document.getElementById('projectStatusCloseBtn');
const projectStatusContainer = document.getElementById(
    'projectStatusContainer'
);
const projectStatusCounter = document.getElementById('projectStatusCounter');
const projectStatusFormFm = document.getElementById('projectStatusFormFm');
const projectStatusAddBtn = document.getElementById('projectStatusAddBtn');
let projects = [];
let currentProject = '';
const defaultStatuses = ['TODO', 'In Progress', 'Done'];

if (todoAddBtn && todoForm && todoCloseBtn) {
    todoAddBtn.addEventListener('click', () => {
        todoForm.showModal();
        todoDeleteBtn.style.display = 'none';
    });
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

if (todoDeleteBtn && todoForm && todoFormFm) {
    // Delete button for TODO
    todoDeleteBtn.addEventListener('click', () => {
        const todoData = new FormData(todoFormFm);
        const id = todoData.get('id');
        const curProject = getCurrentProject();
        if (id) {
            const getTodoIdx = curProject.todos.findIndex((t) => t.id === id);
            if (getTodoIdx > -1) {
                curProject.todos.splice(getTodoIdx, 1);
            }
        }
        todoForm.close();
        displayKanban();
        todoFormFm.reset();
    });
}

if (projectStatusForm && projectStatusesBtn && projectStatusCloseBtn) {
    projectStatusesBtn.addEventListener('click', () => {
        projectStatusForm.showModal();
        if (projectStatusContainer && projectStatusCounter) {
            projectStatusContainer.innerHTML = '';
            const curProject = getCurrentProject();
            let cnt = 0;
            for (const stat of curProject.statuses) {
                addStatus(cnt, stat);
                cnt++;
            }
            projectStatusCounter.value = cnt.toString();
        }
    });
    projectStatusCloseBtn.addEventListener('click', () =>
        projectStatusForm.close()
    );
}

if (projectStatusFormFm) {
    projectStatusFormFm.addEventListener('submit', () => {
        const statusData = new FormData(projectStatusFormFm);
        const statusDict = Object.fromEntries(statusData);
        // console.log('statuses', statusDict);
        const newStatusDict = [];
        for (const key in statusDict) {
            // console.log(key, statusDict[key]);
            if (key.startsWith('status')) {
                newStatusDict.push(statusDict[key]);
            }
        }
        const curProject = getCurrentProject();
        curProject.statuses = [...new Set(newStatusDict)];
        displayKanban();
    });
}

/**
 * Remove a status control
 * @param {number} num
 */
function removeStatus(num) {
    document.getElementById(`projectStatusInputLbl${num}`).remove();
    document.getElementById(`projectStatusRemoveBtn${num}`).remove();
}

/**
 * Add a status to the form
 * @param {number} cnt
 * @param {string} stat
 */
function addStatus(cnt, stat) {
    if (projectStatusContainer) {
        const statInputID = `projectStatusInput${cnt}`;
        const statInputLbl = document.createElement('label');
        statInputLbl.textContent = 'Status';
        statInputLbl.htmlFor = statInputID;
        statInputLbl.id = `projectStatusInputLbl${cnt}`;

        const statInput = document.createElement('input');
        statInput.type = 'text';
        statInput.name = `status${cnt}`;
        statInput.id = statInputID;
        statInput.value = stat;
        statInput.className = 'form-control';
        statInputLbl.appendChild(statInput);
        projectStatusContainer.appendChild(statInputLbl);

        const statRemove = document.createElement('button');
        statRemove.type = 'button';
        statRemove.className = 'btn btn-danger';
        statRemove.textContent = 'Remove';
        statRemove.id = `projectStatusRemoveBtn${cnt}`;
        statRemove.addEventListener('click', () => removeStatus(cnt));
        projectStatusContainer.appendChild(statRemove);

        projectStatusContainer.appendChild(document.createElement('br'));
    }
}

if (projectStatusAddBtn) {
    projectStatusAddBtn.addEventListener('click', () => {
        if (projectStatusCounter) {
            let cnt = parseInt(projectStatusCounter.value);
            addStatus(cnt, '');
            projectStatusCounter.value = (cnt + 1).toString();
        }
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
        const taskTitleH2 = document.querySelector('#todoFormFm h2');
        taskTitleH2.textContent = 'Add Todo';
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
        if (curProjectNotes) {
            curProjectNotes.value = curProject.notes;
            curProjectNotes.addEventListener('change', () => {
                curProject.notes = curProjectNotes.value;
                console.log('change', curProject);
            });
        }
        for (const stat of curProject.statuses) {
            const statDiv = document.createElement('div');
            const statTitle = document.createElement('h2');
            statTitle.textContent = stat;
            statDiv.appendChild(statTitle);
            statDiv.className = 'kanbanColumn';
            statDiv.addEventListener('dragover', (ev) => {
                ev.preventDefault();
                ev.dataTransfer.dropEffect = 'move';
            });
            statDiv.addEventListener('drop', (ev) => {
                ev.preventDefault();
                const data = ev.dataTransfer.getData('text/plain');
                const todoIdx = curProject.todos.findIndex(
                    (t) => t.id === data
                );
                if (todoIdx > -1) {
                    curProject.todos[todoIdx].status = stat;
                }
                const selector = `[${'data-id'}='${data}']`;
                ev.target.appendChild(document.querySelector(selector));
            });

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
                const taskEditBtn = document.createElement('button');
                taskEditBtn.className = 'btn btn-primary';
                taskEditBtn.type = 'button';
                taskEditBtn.textContent = 'Edit';
                taskEditBtn.addEventListener('click', () =>
                    showEditTask(task.id)
                );

                taskDiv.appendChild(taskEditBtn);

                taskDiv.draggable = true;
                taskDiv.addEventListener('dragstart', (ev) => {
                    ev.dataTransfer.setData(
                        'text/plain',
                        ev.target.getAttribute('data-id')
                    );
                    ev.dataTransfer.dropEffect = 'move';
                });

                statDiv.appendChild(taskDiv);
            }

            kanbanBoard.appendChild(statDiv);
        }
    }
}

/**
 * Show the edit form
 * @param {string} taskID
 */
function showEditTask(taskID) {
    if (todoForm) {
        // Get the task info
        const curProject = getCurrentProject();
        const taskIdx = curProject.todos.findIndex((t) => t.id === taskID);
        if (taskIdx > -1) {
            const task = curProject.todos[taskIdx];
            const todoTitle = document.getElementById('todoTitle');
            todoTitle.value = task.title;

            const taskTitleH2 = document.querySelector('#todoFormFm h2');
            taskTitleH2.textContent = 'Edit Todo';

            const todoDescription = document.getElementById('todoDescription');
            todoDescription.value = task.description;

            const todoDueDate = document.getElementById('todoDueDate');
            todoDueDate.value = task.dueDate;

            const todoPriority = document.getElementById('todoPriority');
            todoPriority.value = task.priority;

            const todoStatusSel = document.getElementById('todoStatusSel');
            todoStatusSel.value = task.status;

            const todoId = document.getElementById('todoId');
            todoId.value = task.id;
        }
        todoDeleteBtn.style.display = 'inline-block';
        todoForm.showModal();
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
