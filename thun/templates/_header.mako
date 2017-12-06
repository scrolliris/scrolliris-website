<div class="announcement" align="center">
  <p>${_('announcement.beta')|n,trim,clean(tags=['a', 'span'], attributes=['class', 'href'])}</p>
</div>

<header class="grid" align="left">
  <div class="row">
    <div class="offset-3 column-10 offset-v-1 column-v-14" align="left">
      <a class="brand" href="/">
        <h1 class="logo">
          <img class="logo-mark" width="26" height="26" src="${util.static_url('img/scrolliris-logo-f0ede6-64x64.png')}" alt="Scrolliris's Logo"><span class=logo-type><span class="scroll">Scroll</span><span class="iris">iris</span></span>
        </h1>
      </a>
      <%include file='./_nav.mako'/>
    </div>
  </div>
</header>
