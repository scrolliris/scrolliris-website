<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width,initial-scale=1.0">
    ## avoid miss-extraction by `xgetttext`
    <% meta_description = _('meta.description') %><meta name="description" content="${meta_description}">
    <% meta_keywords = _('meta.keywords') %><meta name="keywords" content="${meta_keywords}">
    <% meta_author = _('meta.author') %><meta name="author" content="${meta_author}">
    <title><%block name='title'>${_('application.name')} - ${_('application.short_description')}</%block></title>
    <link rel="shortcut icon" type="image/x-icon" href="${req.route_url('index') + 'favicon.ico'}">
    <link rel="icon" type="image/x-icon" sizes="16x16 32x32 48x48 64x64 96x96 128x128 192x192" href="/favicon.ico">
    <link rel="icon" type="image/png" sizes="192x192" href="${req.util.static_path('img/favicon-192.png')}">
    <link rel="icon" type="image/png" sizes="128x128" href="${req.util.static_path('img/favicon-128.png')}">
    <link rel="icon" type="image/png" sizes="96x96" href="${req.util.static_path('img/favicon-96.png')}">
    <link rel="icon" type="image/png" sizes="64x64" href="${req.util.static_path('img/favicon-64.png')}">
    <link rel="icon" type="image/png" sizes="48x48" href="${req.util.static_path('img/favicon-48.png')}">
    <link rel="icon" type="image/png" sizes="32x32" href="${req.util.static_path('img/favicon-32.png')}">
    <link rel="icon" type="image/png" sizes="16x16" href="${req.util.static_path('img/favicon-16.png')}">
    <link rel="apple-touch-icon" type="image/png" sizes="180x180" href="${req.util.static_path('img/touch-icon-180.png')}">
    <link rel="apple-touch-icon" type="image/png" sizes="167x167" href="${req.util.static_path('img/touch-icon-167.png')}">
    <link rel="apple-touch-icon" type="image/png" sizes="152x152" href="${req.util.static_path('img/touch-icon-152.png')}">
    <link rel="apple-touch-icon" type="image/png" sizes="120x120" href="${req.util.static_path('img/touch-icon-120.png')}">
    <link rel="apple-touch-icon" type="image/png" sizes="76x76" href="${req.util.static_path('img/touch-icon-76.png')}">
    <link rel="apple-touch-icon" type="image/png" sizes="57x57" href="${req.util.static_path('img/touch-icon-57.png')}">
    <link rel="humans" type="text/plain" href="/humans.txt">
    <link rel="robots" type="text/plain" href="/robots.txt">
    <style>html{background-color:#454545;}</style>
    <style>.not-ready{visibility: hidden;}</style>
    <link rel="stylesheet" href="${req.util.hashed_asset_url('master.css')}">
    <script><%include file='thun:assets/_fouc.js'/></script>
    <link href="//fonts.googleapis.com/css?family=Open+Sans|Roboto+Slab:300" rel="stylesheet">
    <%block name='extra_style'/>
  </head>
  <body>
    <div class="wrapper" align="center">
      <%block name='header'>
        <%include file='_header.mako'/>
      </%block>
      <%block name='nav'></%block>
      ${self.body()}
      <%block name='footer'>
        <%include file='_footer.mako'/>
      </%block>
    </div>

    ## TODO: cache
    <%block>
    <svg xmlns="http://www.w3.org/2000/svg" style="display:none;">
    <%
      filename = 'master.svg'
      svg_file = req.util.manifest_json.get(filename, 'img/' + filename)
    %>
    ${svg_content_sanitized(svg_file, tags=['symbol', 'defs', 'path'], attributes={'symbol': ['id'], 'path': ['id', 'd', 'transform']})|n,trim}
    </svg>
    </%block>

    <%include file='_chat.mako'/>
    <script type="text/javascript" src="${req.util.hashed_asset_url('master.js')}"></script>
    <%block name='extra_script'/>
  </body>
</html>
