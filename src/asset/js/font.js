import FontFaceObserver from 'fontfaceobserver-es/dist/fontfaceobserver.esm.js';

var font;

font = new FontFaceObserver('Roboto Slab');
font.load().then(function() {
  document.body.classList.add('slab-loaded');
});

font = new FontFaceObserver('Open Sans');
font.load().then(function() {
  document.body.classList.add('sans-loaded');
});
