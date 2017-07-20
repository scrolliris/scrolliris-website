<%inherit file='./_layout.mako'/>

<%block name='title'>
 ${_('timeline.title')} | ${_('application.name')}
</%block>

<div class="header" align="center">
  <img width="64" height"64" src="${util.static_url('img/scrolliris-logo-64x64.png')}">
  <h1><span class="scroll">Scroll</span><span class="iris">iris</span></h1>
  <ul class="nav">
    <li><a class="overview link" href="/">${_('nav.header.overview')}</a></li>
    <li><a class="timeline active link" href="${req.route_path('timeline')}">${_('nav.header.timeline')}</a></li>
    <li><a class="newsletter link" href="${var['tinyletter_url']}">${_('nav.header.newsletter')}</a></li>
  </ul>
</div>

<div class="container" align="center">
  <div class="grid timeline" align="center">
    <div class="row">
      <div class="col-8 off-4">
        <p>TBD</p>
      </div>
    </div>
</div>
