import json
import logging
from os import path

from paste.translogger import TransLogger
from pyramid.config import Configurator
from pyramid.decorator import reify
from pyramid.events import subscriber, BeforeRender, NewRequest
import pyramid.httpexceptions as exc
from pyramid.i18n import TranslationString
from pyramid.response import Response
from pyramid.view import view_config
from pyramid.threadlocal import get_current_registry
from pyramid.view import notfound_view_config

from wsgiref.handlers import BaseHandler
import sys

from .env import Env

STATIC_DIR = path.join(path.dirname(path.abspath(__file__)), '../static')


# -- functions

# broken pipe error
def ignore_broken_pipes(self):
    if sys.exc_info()[0] != BrokenPipeError:
        BaseHandler.__handle_error_original_(self)


BaseHandler.__handle_error_original_ = BaseHandler.handle_error
BaseHandler.handle_error = ignore_broken_pipes


def get_settings():
    """ Returns settings from current ini.
    """
    return get_current_registry().settings


def get_translator_function(localizer):
    def translate(*args, **kwargs):
        if 'domain' not in kwargs:
            kwargs['domain'] = 'message'
        ts = TranslationString(*args, **kwargs)
        return localizer.translate(ts)
    return translate


def resolve_env_vars(settings):
    env = Env()
    s = settings.copy()
    for k, v in env.settings_mappings.items():
        # ignores missing key or it has a already value in config
        if k not in s or s[k]:
            continue
        new_v = env.get(v, None)
        if not isinstance(new_v, str):
            continue
        # ignores empty string
        if ',' in new_v:
            s[k] = [nv for nv in new_v.split(',') if nv != '']
        elif new_v:
            s[k] = new_v
    return s


def tpl(path):
    return './templates/{0:s}'.format(path)


# -- logger

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

sh = logging.StreamHandler()
sh.setLevel(logging.INFO)
sh.setFormatter(logging.Formatter('%(message)s'))
logger.addHandler(sh)


# -- utils

class TemplateUtil(object):
    """
    The utility for templates.
    """
    def __init__(self, ctx, req, **kwargs):
        self.context, self.req = ctx, req

        if getattr(req, 'util', None) is None:
            req.util = self
        self.__dict__.update(kwargs)

    @reify
    def manifest_json(self):
        manifest_file = path.join(
            path.dirname(__file__), '..', 'static', 'manifest.json')
        data = {}
        if path.isfile(manifest_file):
            with open(manifest_file) as data_file:
                data = json.load(data_file)

        return data

    def is_matched(self, matchdict):
        return self.req.matchdict == matchdict

    def static_url(self, path):
        return self.req.static_url(STATIC_DIR + '/' + path)

    def static_path(self, path):
        return self.req.static_path(STATIC_DIR + '/' + path)

    def built_asset_url(self, path):
        path = self.manifest_json.get(path, path)
        return self.static_url(path)

    @reify
    def var(self):  # pylint: disable=no-self-use
        """ Return a dict has variables
        """
        env = Env()
        return {  # external services
            'gitlab_url': env.get('GITLAB_URL', '/'),
            'tinyletter_url': env.get('TINYLETTER_URL', '/'),
            'twitter_url': env.get('TWITTER_URL', '/'),
            'typekit_id': env.get('TYPEKIT_ID', ''),
            'userlike_script': env.get('USERLIKE_SCRIPT', '/'),
        }


# -- views

@notfound_view_config(renderer=tpl('404.mako'),
                      append_slash=exc.HTTPMovedPermanently)
def notfound(request):
    request.response.status = 404
    return {}


@view_config(context=exc.HTTPInternalServerError, renderer='string')
def internal_server_error(req):
    body = 'Cannot {} {}'.format(req.method, req.path)
    return Response(body, status='500 Internal Server Error')


@view_config(route_name='index', renderer=tpl('index.mako'),
             request_method='GET')
def index(req):
    """ Overview.
    """
    return dict()


@view_config(route_name='timeline',
             renderer=tpl('timeline.mako'), request_method='GET')
def timeline(req):
    """ Timeline.
    """
    return dict()

# FIXME
# @view_config(route_name='term',
#              renderer=tpl('term.mako'), request_method='GET')
# def term(req):
#     return dict()
#
#
# @view_config(route_name='policy',
#              renderer=tpl('policy.mako'), request_method='GET')
# def policy(req):
#     return dict()


# -- subscribers

@subscriber(NewRequest)
def add_localizer(evt):
    req = evt.request
    res = req.response

    env = Env()
    if env.get('ENV', 'production') != 'production':
        res.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'

    if req:
        localizer = req.localizer
        req.translate = get_translator_function(localizer)


@subscriber(BeforeRender)
def add_renderer_globals(evt):
    ctx, req = evt['context'], evt['request']
    util = getattr(req, 'util', None)

    # `util` in template
    if util is None and req is not None:
        util = TemplateUtil(ctx, req)
        evt['util'] = util

    # shortcut method for template
    if req and hasattr(req, 'translate'):
        _ = req.translate
        if _:
            evt['_'] = _
            # the keys for this method will be skiped at extraction
            evt['__'] = _

    evt['var'] = util.var


# -- main

def main(_, **settings):
    """ The main function.
    """
    from .request import CustomRequest

    config = Configurator(settings=resolve_env_vars(settings))

    env = Env()
    cache_max_age = 3600 if env.is_production else 0

    # routes
    # static files at /*
    filenames = [f for f in ('robots.txt', 'humans.txt', 'favicon.ico')
                 if path.isfile((STATIC_DIR + '/{}').format(f))]
    if filenames:
        config.add_asset_views(
            STATIC_DIR, filenames=filenames, http_cache=cache_max_age)

    # static files at /assets/*
    config.add_static_view(
        name='assets', path=STATIC_DIR, cache_max_age=cache_max_age)

    config.add_route('index', '/')  # overview
    config.add_route('timeline', '/timeline')
    # FIXME
    # config.add_route('policy', '/policy')
    # config.add_route('term', '/term')

    config.add_translation_dirs('tirol:../locale')

    config.set_request_factory(CustomRequest)

    config.scan()
    app = config.make_wsgi_app()
    app = TransLogger(app, setup_console_handler=False)
    return app
