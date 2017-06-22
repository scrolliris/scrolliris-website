<div class="newsletter">
  <p>${_('newsletter.description')}<br>
    <label for="email">${_('newsletter.label')}</label></p>
  <form action="${var['newsletter_link']}" method="post" target="popupwindow" onsubmit="window.open('${var['newsletter_link']}', 'popupwindow', 'scrollbars=yes,width=800,height=600');return true">
    <input type="text" name="email" id="email" />
    <input type="hidden" value="1" name="embed"/>
    <input class="secondary btn" type="submit" value="${_('newsletter.subscribe.button')}" />
  </form>
</div>
