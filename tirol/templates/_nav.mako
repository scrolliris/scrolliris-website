<%block name='nav'>
<div class="global-nav">
  <ul class="nav" align="center">
    <li><a class="overview${' active' if req.path == '/' else ''} link" href="/">${_('nav.header.overview')}</a></li>
    <li><a class="timeline${' active' if req.path == '/timeline' else ''} link" href="${req.route_path('timeline')}">${_('nav.header.timeline')}</a></li>
    <li><a class="pricing${' active' if req.path == '/pricing' else ''} link" href="${req.route_path('pricing')}">${_('nav.header.pricing')}</a></li>
    <li><a class="newsletter link" href="${var['tinyletter_url']}" target="_blank">${_('nav.header.newsletter')}</a></li>
    <li><a class="login link" href="https://scrolliris.com/login">${_('nav.header.login')}</a></li>
  </ul>
</div>
</%block>
