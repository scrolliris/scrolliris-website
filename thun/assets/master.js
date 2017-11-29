// vendor components
require('styr.css')
require('open-iconic.svg')

// application styles
require('./css/style.styl')
require('./css/layout.styl')
require('./css/typography.styl')
require('./css/timeline.styl')


var timeline = document.getElementById('timeline');
if (timeline) {
  var doc = document.documentElement;
  var blocks = timeline.querySelectorAll('.timeline-block');
  window.addEventListener('scroll', function() {
    for (var i = 0; i < blocks.length; i++) {
      var block = blocks[i]
        , content = block.querySelector('.timeline-content')
        ;
      var windowOffsetTop = (window.pageYOffset || doc.scrollTop) -
                            (doc.clientTop || 0);
      if ((block.offsetTop <= windowOffsetTop*1.1) &&
          content.classList.contains('is-hidden')) {
        content.classList.remove('is-hidden');
        content.classList.add('bounce-in');
      }
    }
  });
}
