<%inherit file='./_layout.mako'/>

<%block name='title'>${_('timeline.title')} | ${_('application.name')}</%block>

<%include file='./_nav.mako'/>

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
              <h2 class="heading">${__('timeline.entry.'+number+'.title', domain='timeline')}</h2>
              <span class="timeline-date">${__('timeline.entry.'+number+'.date', domain='timeline')|n,trim,clean(tags=['del'])}</span>
              <p>${__('timeline.entry.'+number+'.description', domain='timeline')|n,trim,clean(tags=['a', 'br', 'del', 'img'], attributes={'a': ['href', 'target'], 'img': ['src', 'width', 'height', 'style']})}</p>
            </div>
          </div>
        </%def>

        ## translation is looked up via `__` + domain from timeline.pot
        <section id="timeline">
          ${timeline_block(icon='question-mark', number='007', is_hidden=False)}
          ${timeline_block(icon='browser', number='006', is_hidden=False)}
          ${timeline_block(icon='people', number='005', is_hidden=False)}
          ${timeline_block(icon='flag', number='004')}
          ${timeline_block(icon='heart', number='003')}
          ${timeline_block(icon='eye', number='002')}
          ${timeline_block(icon='power-standby', number='001')}
        </section>
      </div>
    </div>
  </div>
</div>
