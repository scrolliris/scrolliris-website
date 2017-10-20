<div class="customer">
  <p>${_('customer.description')}<br>
  <div class="row">
    <div class="offset-2 column-4 column-v-8 column-n-16" align=center>
      <div class="attached box">
        <div class="thumb">
          <a href="https://ch.oddb.org/" target="_blank"><img src="https://img.scrolliris.io/user/logo/oddb.png" height="120" /></a>
        </div>
        <div class="header">
          <span>Open Drug Database</span>
        </div>
        <p class="description">${_('customer.description.01', mapping={'href': 'https://ch.oddb.org'})|n,trim,clean(tags=['a'], attributes={'a': ['class', 'href', 'target']})}</p>
      </div>
      <div class="attached footer">
        <span class="location">${_('customer.location.switzerland')}</span>
      </div>
    </div>
    <div class="column-4 column-v-8 column-n-16" align=center>
      <div class="attached box">
        <div class="thumb">
          <a href="http://www.ywesee.com/" target="_blank"><img src="https://img.scrolliris.io/user/logo/ywesee-gmbh.png" height="120" /></a>
        </div>
        <div class="header">
          <span>ywesee GmbH</span>
        </div>
        <p class="description">${_('customer.description.02', mapping={'href': 'http://www.ywesee.com/'})|n,trim,clean(tags=['a'], attributes={'a': ['class', 'href', 'target']})}</p>
      </div>
      <div class="attached footer">
        <span class="location">${_('customer.location.switzerland')}</span>
      </div>
    </div>
    <div class="mobile-hidden column-4 offset-v-4 column-v-8 column-n-16" align=center>
      <div class="flat attached none box">
      </div>
      <div class="attached flat none footer">
      </div>
    </div>
  </div>
</div>
