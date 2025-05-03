import './styles.css';
console.log('Test!');
import { mainContent } from './homePage';
import { menuPage } from './menuPage';
import { aboutContent } from './aboutPage';
mainContent();

const homeBtn = document.getElementById('homeBtn');
if (homeBtn) {
  homeBtn.addEventListener('click', mainContent);
}
const menuBtn = document.getElementById('menuBtn');
if (menuBtn) {
  menuBtn.addEventListener('click', menuPage);
}
const aboutBtn = document.getElementById('aboutBtn');
if (aboutBtn) {
  aboutBtn.addEventListener('click', aboutContent);
}
