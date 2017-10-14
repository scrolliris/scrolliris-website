<%inherit file='./_layout.mako'/>

<%block name='title'>${_('timeline.title')} | ${_('application.name')}</%block>

<div class="header" align="center">
  <a href="/"><img width="32" height"32" src="${util.static_url('img/scrolliris-logo-64x64.png')}"></a>
  <ul class="nav">
    <li><a class="overview link" href="/">${_('nav.header.overview')}</a></li>
    <li><a class="timeline active link" href="${req.route_path('timeline')}">${_('nav.header.timeline')}</a></li>
    <li><a class="newsletter link" href="${var['tinyletter_url']}">${_('nav.header.newsletter')}</a></li>
    <li><a class="login link" href="https://scrolliris.com/login">${_('nav.header.login')}</a></li>
  </ul>
</div>

<div class="content" align="center">
  <div class="grid timeline" align="center">
    <div class="row">
      <div class="column-16">

        <%def name="timeline_block(icon, number, is_hidden=True)">
          <div class="timeline-block">
            <div class="timeline-icon">
              <svg class="small icon ${icon}" viewBox="0 0 8 8" width="24" height="24">
              <use xlink:href="#open-iconic.min_${icon}" class="icon-${icon}"></use>
              </svg>
            </div>
            <div class="timeline-content${' is-hidden' if is_hidden else ' bounce-in'}">
              <h2>${__('timeline.entry.'+number+'.title', domain='timeline')}</h2>
              <span class="timeline-date">${__('timeline.entry.'+number+'.date', domain='timeline')|n,trim,clean(tags=['del'])}</span>
              <p>${__('timeline.entry.'+number+'.description', domain='timeline')|n,trim,clean(tags=['a', 'br', 'del', 'img'], attributes={'a': ['href', 'target'], 'img': ['src', 'width', 'height', 'style']})}</p>
            </div>
          </div>
        </%def>

        ## translation is looked up via `__` + domain from timeline.pot
        <section id="timeline">
          ${timeline_block(icon='flag', number='004', is_hidden=False)}
          ${timeline_block(icon='heart', number='003', is_hidden=False)}
          ${timeline_block(icon='eye', number='002')}
          ${timeline_block(icon='power-standby', number='001')}
        </section>
      </div>
    </div>
  </div>
</div>
