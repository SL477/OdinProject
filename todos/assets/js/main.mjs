import TODO from './todo.mjs';

const todoAddBtn = document.getElementById('todoAddBtn');
const todoForm = document.getElementById('todoForm');
const todoCloseBtn = document.getElementById('todoCloseBtn');
const todoFormFm = document.getElementById('todoFormFm');

if (todoAddBtn && todoForm && todoCloseBtn) {
    todoAddBtn.addEventListener('click', () => todoForm.showModal());
    todoCloseBtn.addEventListener('click', () => todoForm.close());
}

//#region TODOForm
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
