export function aboutContent() {
  const divContent = document.getElementById('content');
  if (divContent) {
    divContent.innerHTML = '';
    const title = document.createElement('h1');
    title.textContent = 'About';
    divContent.appendChild(title);
    const blurb = document.createElement('p');
    blurb.textContent =
      'The Odin Cafe is situated on Victoria Spaceport. Just outside the space elevator complex and offering unrivalled views of near Earth orbit. We source only the best ingredients from Earth and the Sol System.';
    divContent.appendChild(blurb);
  }
}
