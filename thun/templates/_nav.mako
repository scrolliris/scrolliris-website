<%block name='nav'>
  <div class="global-nav" align="right">
    <ul class="nav">
      <li><a class="overview${' active' if req.path == '/' else ''} link" href="/">${_('nav.header.overview')}</a></li>
      <li><a class="timeline${' active' if req.path == '/timeline' else ''} link" href="${req.route_path('timeline')}">${_('nav.header.timeline')}</a></li>
      <li><a class="pricing${' active' if req.path == '/pricing' else ''} link" href="${req.route_path('pricing')}">${_('nav.header.pricing')}</a></li>
      <li><a class="login signup link" href="https://scrolliris.com/signup">${_('nav.header.login_or_signup')}</a></li>
    </ul>
  </div>

  <div class="mobile nav" align="right">
    <label for="dropdown" class="toggle">☰</label>
    <input type="checkbox" id="dropdown">
    <ul class="menu" align="left">
      <li><a class="overview${' active' if req.path == '/' else ''} link" href="/">${_('nav.header.overview')}</a></li>
      <li><a class="timeline${' active' if req.path == '/timeline' else ''} link" href="/timeline">${_('nav.header.timeline')}</a></li>
      <li><a class="pricing${' active' if req.path == '/pricing' else ''} link" href="/pricing">${_('nav.header.pricing')}</a></li>
      <li><a class="login signup link" href="https://scrolliris.com/signup">${_('nav.header.signup')}</a></li>
    </ul>
  </div>
</%block>
