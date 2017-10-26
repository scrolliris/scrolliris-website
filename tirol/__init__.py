import sys
from wsgiref.handlers import BaseHandler

from pyramid.config import Configurator
from pyramid.events import subscriber, BeforeRender, NewRequest
import pyramid.httpexceptions as exc
from pyramid.i18n import TranslationString
from pyramid.response import Response
from pyramid.view import view_config
from pyramid.threadlocal import get_current_registry
from pyramid.view import notfound_view_config
import better_exceptions

from tirol.env import Env
import tirol.logger  # noqa

better_exceptions.MAX_LENGTH = None


# -- util

# broken pipe error
def ignore_broken_pipes(self):
    # pylint: disable=protected-access
    if sys.version_info[0] > 2:
        # pylint: disable=undefined-variable
        if sys.exc_info()[0] != BrokenPipeError:  # noqa
            BaseHandler.__handle_error_original_(self)


# pylint: disable=protected-access
BaseHandler.__handle_error_original_ = BaseHandler.handle_error
BaseHandler.handle_error = ignore_broken_pipes
# pylint: enable=protected-access


def get_settings():
    """Returns settings from current ini."""
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


def tpl(filepath):
    return './templates/{0:s}'.format(filepath)


# -- view

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
def index(_req):
    return dict()


@view_config(route_name='pricing', renderer=tpl('pricing.mako'),
             request_method='GET')
def pricing(_req):
    return dict()


@view_config(route_name='timeline',
             renderer=tpl('timeline.mako'), request_method='GET')
def timeline(_req):
    return dict()


# -- subscriber

@subscriber(NewRequest)
def add_cache_control(evt):
    req = evt.request
    res = req.response

    env = Env()
    if env.get('ENV', 'production') != 'production':
        res.headers['Cache-Control'] = 'no-cache, no-store, must-revalidate'


@subscriber(NewRequest)
def add_localizer(evt):
    """Adds translator function as `req.translate`.

    Access this function from `_` or `__` (see renderer global variables)
    """
    req = evt.request

    if req:
        localizer = req.localizer
        req.translate = get_translator_function(localizer)


@subscriber(BeforeRender)
def add_renderer_globals(evt):
    _, req = evt['context'], evt['request']

    # shortcut method for template
    if req and hasattr(req, 'translate'):
        _ = req.translate
        if _:
            evt['_'] = _
            # the keys for this method will be skiped at extraction
            evt['__'] = _


# -- entry point

def main(_, **settings):
    from tirol.request import CustomRequest

    config = Configurator(settings=resolve_env_vars(settings))

    config.include('.route')

    config.add_translation_dirs('tirol:../locale')

    config.set_request_factory(CustomRequest)

    config.scan()
    app = config.make_wsgi_app()

    # from tirol.logger import enable_translogger
    # app = enable_translogger(app)
    return app
