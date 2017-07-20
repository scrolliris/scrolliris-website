<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    <meta name="description" content="${_('meta.description')}">
    <meta name="author" content="${_('meta.author')}">
    <title><%block name='title'/></title>
    <link rel="stylesheet" href="${req.util.built_asset_url('master.css')}">
    <link rel="shortcut icon" type="image/x-icon" href="${req.util.static_url('favicon.ico')}">
    <link rel="icon" type="image/x-icon" sizes="16x16 32x32 48x48 64x64 96x96 128x128 256x256" href="${req.util.static_path('favicon.ico')}">
    <link rel="icon" type="image/png" sizes="256x256" href="${req.util.static_path('img/favicon-256.png')}">
    <link rel="icon" type="image/png" sizes="128x128" href="${req.util.static_path('img/favicon-128.png')}">
    <link rel="icon" type="image/png" sizes="96x96" href="${req.util.static_path('img/favicon-96.png')}">
    <link rel="icon" type="image/png" sizes="64x64" href="${req.util.static_path('img/favicon-64.png')}">
    <link rel="icon" type="image/png" sizes="48x48" href="${req.util.static_path('img/favicon-48.png')}">
    <link rel="icon" type="image/png" sizes="32x32" href="${req.util.static_path('img/favicon-32.png')}">
    <link rel="icon" type="image/png" sizes="16x16" href="${req.util.static_path('img/favicon-12.png')}">
    <link rel="humans" href="/humans.txt" type="text/plain">
    <link rel="robots" href="/robots.txt" type="text/plain">
    <%block name='header'/>
  </head>
  <body>
    <div class="wrapper" align="center">
      <div class="announcement" align="center">
        <p>${_('announcement.beta')}</p>
      </div>
      ${self.body()}
      <%block name='footer'>
        <%include file='footer.mako'/>
      </%block>
    </div>

    <%def name="add_icons(svg_file)">
    ## img/FILE.[hash].svg
    <% svg_file = req.util.manifest_json.get(svg_file, 'img/' + svg_file) %>
    <%include file='../../static/${svg_file}'/>
    </%def>
    <svg xmlns="http://www.w3.org/2000/svg" style="display:none;">
    <% add_icons('vendor.svg') %>
    </svg>

    <%include file='./_font.mako'/>
    <%include file='./_chat.mako'/>
    <script src="${req.util.built_asset_url('master.js')}"></script>
  </body>
</html>
