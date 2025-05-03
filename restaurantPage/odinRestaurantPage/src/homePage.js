/* <h1>Odin Cafe</h1>
      <img src="/images/odinCafe.png" alt="Odin Cafe" />
      <p>
        Here at the Odin Cafe enjoy a pastry while experiencing fantastic views
        of the cosmos!
      </p> */
// import odinCafe from '../images/odinCafe.png';
import odinCafe from './images/odinCafe.png';

export function mainContent() {
  const divContent = document.getElementById('content');
  if (divContent) {
    const title = document.createElement('h1');
    title.textContent = 'Odin Cafe';
    divContent.innerHTML = '';
    divContent.appendChild(title);
    const img = document.createElement('img');
    img.src = odinCafe;
    img.alt = 'Odin Cafe';
    img.title = 'Created using https://www.craiyon.com/';
    divContent.appendChild(img);
    const para = document.createElement('p');
    para.textContent =
      'Here at the Odin Cafe enjoy a pastry while experiencing fantastic views of the cosmos!';
    divContent.appendChild(para);
  }
}
