<%inherit file='./_layout.mako'/>

<%block name='title'>${_('application.name')}</%block>

<div class="header" align="center">
  <img width="64" height="64" src="${util.static_url('img/scrolliris-logo-64x64.png')}" alt="Scrolliris's Logo">
  <h1><span class="scroll">Scroll</span><span class="iris">iris</span></h1>
  <ul class="nav">
    <li><a class="overview active link" href="/">${_('nav.header.overview')}</a></li>
    <li><a class="timeline link" href="${req.route_path('timeline')}">${_('nav.header.timeline')}</a></li>
    <li><a class="newsletter link" href="${var['tinyletter_url']}" target="_blank">${_('nav.header.newsletter')}</a></li>
  </ul>
</div>

<div class="content" align="center">
  <div class="grid title" align="center">
    <div class="row">
      <div class="column-8 offset-4 column-l-14 offset-l-1 column-n-16">
        <h2 class="heading">${_('application.title')}</h2>
        <p class="description">${_('application.description')}</p>
        <div class="get-started">
          <a class="primary try button" href="https://try.scrolliris.com/">${_('get_started.title')}</a>
          <p>${_('get_started.description')}</p>
        </div>
      </div>
    </div>
  </div>

  <div class="grid screenshot">
    <img class="console-screenshot" width="980" src="${util.static_url('img/screenshot.png')}" alt="screenshot">
  </div>

  <div class="grid feature">
    <div class="row">
      <div class="column-16" align="center">
        <h2 class="heading">${_('feature.title')}</h2>
      </div>
    </div>

    <div class="row">
      <div class="column-4 offset-2 column-l-7 offset-l-1 column-m-16" align="center">
        <section>
          <svg class="icon bar-chart" viewBox="0 0 8 8" width="48" height="48">
            <use xlink:href="#open-iconic.min_bar-chart" class="icon-bar-chart"></use>
          </svg>
          <h3 class="heading">${_('feature.analysis.title')}</h3>
          <p class="text">${_('feature.analysis.description')}</p>
        </section>
      </div>
      <div class="column-4 column-l-7 column-m-16" align="center">
        <section>
          <svg class="icon lock-locked" viewBox="0 0 8 8" width="48" height="48">
            <use xlink:href="#open-iconic.min_lock-locked" class="icon-lock-locked"></use>
          </svg>
          <h3 class="heading">${_('feature.privacy.title')}</h3>
          <p class="text">${_('feature.privacy.description')}</p>
        </section>
      </div>
      <div class="column-4 column-l-7 offset-l-4 column-m-16" align="center">
        <section>
          <svg class="icon wrench" viewBox="0 0 8 8" width="48" height="48">
            <use xlink:href="#open-iconic.min_wrench" class="icon-wrench"></use>
          </svg>
          <h3 class="heading">${_('feature.integration.title')}</h3>
          <p class="text">${_('feature.integration.description')}</p>
        </section>
      </div>
    </div>
  </div>

  <div class="grid newsletter">
    <hr class="line">
    <div class="row">
      <div class="column-16" align=center>
        <div class="newsletter-container">
          <h3 class="heading">${_('newsletter.title')}</h3>
          <div class="newsletter-form">
            <%include file='./_newsletter.mako'/>
          </div>
        </div>
      </div>
    </div>
    <hr class="line">
  </div>

  <div class="grid about">
    <div class="row">
      <div class="column-16" align=center>
        <h5><a class="logo" href="https://lupine-software.com/"><img class="logo-img" src="${util.static_url('img/lupine-software-logo-64x64.png')}" width="64px" height="64px" alt="Lupine Software's Logo"></a></h5>
        <p>${_('about.text', mapping={'href': 'https://lupine-software.com/'})|n,trim,clean(tags=['a', 'svg', 'use'], attributes={'a': ['class', 'href'], 'svg': util.allow_svg('0 0 8 8'), 'use': ['href', 'class']})}</p>
      </div>
    </div>
  </div>
</div>
