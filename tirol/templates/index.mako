<%inherit file='./layout.mako'/>

<%block name='title'>
  ${_('application.name')}
</%block>

% if newsletter_form_template:
<%block name='header'>
</%block>
% endif

<div class="header" align="center">
  <h2><img class="logo" src="" width="52px" height="52px" alt="logo"></h2>
  <ul class="nav">
    <li><a class="overview active link" href="/">${_('nav.header.overview')}</a></li>
    <li><a class="roadmap link" href="${req.route_path('roadmap')}">${_('nav.header.roadmap')}</a></li>
    <li><a class="newsletter link" href="${var['tinyletter_url']}" target="_blank">${_('nav.header.newsletter')}</a></li>
  </ul>
</div>

<div class="container" align="center">
  <div class="grid title" align="center">
    <div class="row">
      <h1 class="heading">${_('application.title')}</h1>
      <div class="col-8 off-4">
        <p class="description">${_('application.description')}</p>
        <div class="get-started">
          <a class="primary try btn" href="https://try.scrolliris.com/">${_('get_started.title')}</a>
          <p>${_('get_started.description')}</p>
        </div>
      </div>
    </div>
  </div>

  <div class="grid screenshot">
    <img class="console-screenshot" src="${util.static_url('img/screenshot.png')}" alt="screenshot">
  </div>

  <div class="grid feature">
    <div class="row">
      <div class="col-16" align="center">
        <h2 class="heading">${_('feature.title')}</h2>
      </div>
    </div>

    <div class="row">
      <div class="col-4 off-2" align="center">
        <svg class="icon bar-chart" viewBox="0 0 8 8">
        <use xlink:href="#open-iconic.min_bar-chart" class="icon-bar-chart"></use>
        </svg>
        <h3 class="heading">${_('feature.analysis.title')}</h3>
        <p class="text">${_('feature.analysis.description')}</p>
      </div>
      <div class="col-4" align="center">
        <svg class="icon lock-locked" viewBox="0 0 8 8">
          <use xlink:href="#open-iconic.min_lock-locked" class="icon-lock-locked"></use>
        </svg>
        <h3 class="heading">${_('feature.privacy.title')}</h3>
        <p class="text">${_('feature.privacy.description')}</p>
      </div>
      <div class="col-4" align="center">
        <svg class="icon wrench" viewBox="0 0 8 8">
          <use xlink:href="#open-iconic.min_wrench" class="icon-wrench"></use>
        </svg>
        <h3 class="heading">${_('feature.integration.title')}</h3>
        <p class="text">${_('feature.integration.description')}</p>
      </div>
    </div>
  </div>

  % if newsletter_form_template:
  <div class="grid newsletter">
    <hr class="line">
    <div class="row">
      <div class="col-16" align=center>
        <div class="newsletter-container">
          <h3 class="heading">${_('newsletter.title')}</h3>
          <div class="newsletter-form">
            <%include file='${newsletter_form_template}'/>
          </div>
        </div>
      </div>
    </div>
    <hr class="line">
  </div>
  % endif

  <div class="grid about">
    <div class="row">
      <div class="col-16" align=center>
        <h5><a class="logo" href="/"><img class="logo" src="" width="52px" height="52px" alt="logo"></a></h5>
        <p>${_('about.text', mapping={'href': 'https://lupine-software.com/'})|n,trim}</p>
      </div>
    </div>
  </div>
</div>
