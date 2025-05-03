export function menuPage() {
  const divContent = document.getElementById('content');
  if (divContent) {
    divContent.innerHTML = '';
    const title = document.createElement('h1');
    title.textContent = 'Menu';
    divContent.appendChild(title);
    const items = document.createElement('ul');
    const coffee = document.createElement('li');
    coffee.textContent = '$27 - Coffee';
    items.appendChild(coffee);
    items.className = 'menu';
    const cake = document.createElement('li');
    cake.textContent = '$5 - Chocolate Cake';
    items.appendChild(cake);
    const softDrinks = document.createElement('li');
    softDrinks.textContent = '$7 - Soft Drink';
    items.appendChild(softDrinks);
    divContent.appendChild(items);
  }
}
