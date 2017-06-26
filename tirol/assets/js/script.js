// background image (attachment)
window.addEventListener('scroll', () => {
  let body = document.body
    , html = document.documentElement
    ;

  let percentage = Math.round(100 *
    Math.abs(html.scrollTop / (html.scrollHeight - html.clientHeight)));
  if (percentage >= 66) {
    if (body.classList.contains('fixed')) {
      body.classList.remove('fixed');
    }
  } else if (!body.classList.contains('fixed')) {
    body.classList.add('fixed');
  }
});
