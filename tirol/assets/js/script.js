// background image (attachment)
window.addEventListener('scroll', () => {
  let body = document.body
    , html = document.documentElement
    ;

  // NOTE:
  // Chromium does not have `html.scrollTop` (use `body.scrollTop`)
  let percentage = Math.round(100 *
    Math.abs((html.scrollTop || body.scrollTop) /
             (html.scrollHeight - html.clientHeight)));

  if (percentage >= 40) {
    if (body.classList.contains('fixed')) {
      body.classList.remove('fixed');
    }
  } else if (!body.classList.contains('fixed')) {
    body.classList.add('fixed');
  }
});
