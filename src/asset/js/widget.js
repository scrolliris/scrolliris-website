const params = new URLSearchParams(document.location.search);

const minimap = document.querySelector('#minimap');
const overlay = document.querySelector('#overlay');

if (params.get('type') === 'minimap') {
  minimap.style.display = 'block';
  overlay.style.display = 'none';
} else {
  minimap.style.display = 'none';
  overlay.style.display = 'block';
}
