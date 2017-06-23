<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <!--
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    -->
    <meta name="description" content="${_('meta.description')}">
    <meta name="author" content="${_('meta.author')}">
    <title><%block name='title'/></title>
    <link rel="stylesheet" href="${util.built_asset_url('vendor.css')}">
    <link rel="stylesheet" href="${util.built_asset_url('master.css')}">
    <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
    <link rel="icon" href="/favicon.ico" type="image/x-icon">
    <link rel="humans" href="/humans.txt" type="text/plain">
    <link rel="robots" href="/robots.txt" type="text/plain">
    <%block name='header'/>
  </head>
  <body>
    <%def name="add_icons(svg_file)">
    ## img/FILE.[hash].svg
    <% svg_file = req.util.manifest_json.get(svg_file, 'img/' + svg_file) %>
    <%include file='../../static/${svg_file}'/>
    </%def>
    <svg xmlns="http://www.w3.org/2000/svg" style="display:none;">
    <% add_icons('vendor.svg') %>
    </svg>

    <div class="wrapper" align="center">
      <div class="announcement" align="center">
        ${_('announcement.beta')}
      </div>
      ${self.body()}
      <%block name='footer'>
        <%include file='footer.mako'/>
      </%block>
    </div>

    <script src="${util.built_asset_url('vendor.js')}" charset="utf-8"></script>
    <script src="${util.built_asset_url('master.js')}" charset="utf-8"></script>
    <script>
      (function(d) {
        var config = {
              kitId: '${var['typekit_id']}'
            , scriptTimeout: 3000
            , async: true
            }
          , h=d.documentElement,t=setTimeout(function(){h.className=h.className.replace(/\bwf-loading\b/g,"")+" wf-inactive";},config.scriptTimeout),tk=d.createElement("script"),f=false,s=d.getElementsByTagName("script")[0],a;h.className+=" wf-loading";tk.src='https://use.typekit.net/'+config.kitId+'.js';tk.async=true;tk.onload=tk.onreadystatechange=function(){a=this.readyState;if(f||a&&a!="complete"&&a!="loaded")return;f=true;clearTimeout(t);try{Typekit.load(config)}catch(e){}};s.parentNode.insertBefore(tk,s)
      })(document);
    </script>
    <%include file='./chat.mako'/>
  </body>
</html>
