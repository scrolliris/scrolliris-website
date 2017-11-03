import json
from os import path

from bleach import clean as _clean
from markupsafe import Markup
from pyramid.decorator import reify
from pyramid.events import subscriber
from pyramid.events import BeforeRender

from tirol.env import Env


@subscriber(BeforeRender)
def add_template_utilities(evt):  # type: (dict) -> None
    """Adds utility functions for templates."""
    ctx, req = evt['context'], evt['request']
    util = getattr(req, 'util', None)

    # `util` in template
    if util is None and req is not None:
        util = TemplateUtility(ctx, req)

    evt['util'] = util
    evt['var'] = util.var

    evt['clean'] = clean


class TemplateUtility(object):
    # pylint: disable=no-self-use

    def __init__(self, ctx, req, **kwargs):
        self.context, self.req = ctx, req

        if getattr(req, 'util', None) is None:
            req.util = self
        self.__dict__.update(kwargs)

    @reify
    def manifest_json(self):
        manifest_file = path.join(self.project_root, 'static', 'manifest.json')
        data = {}
        if path.isfile(manifest_file):
            with open(manifest_file) as data_file:
                data = json.load(data_file)

        return data

    @reify
    def project_root(self):
        return path.join(path.dirname(__file__), '..')

    @reify
    def var(self):  # pylint: disable=no-self-use
        """Returns a dict has variables."""
        env = Env()
        return {  # external services
            'gitlab_url': env.get('GITLAB_URL', '/'),
            'tinyletter_url': env.get('TINYLETTER_URL', '/'),
            'twitter_url': env.get('TWITTER_URL', '/'),
            'typekit_id': env.get('TYPEKIT_ID', ''),
            'userlike_script': env.get('USERLIKE_SCRIPT', '/'),
        }

    def is_matched(self, matchdict):
        return self.req.matchdict == matchdict

    def static_url(self, filepath):
        from tirol.route import STATIC_DIR
        return self.req.static_url(STATIC_DIR + '/' + filepath)

    def static_path(self, filepath):
        from tirol.route import STATIC_DIR
        return self.req.static_path(STATIC_DIR + '/' + filepath)

    def built_asset_url(self, filepath):
        filepath = self.manifest_json.get(filepath, filepath)
        return self.static_url(filepath)

    def allow_svg(self, size):  # type: (str) -> 'function'
        """Returns actual allow_svg as function allowing given size."""
        def _allow_svg(tag, name, value):  # type: (str, str, str) -> bool
            """Returns True if tag is svg and it has allowed attrtibutes."""
            if tag == 'svg' and name in ('width', 'height', 'class'):
                return True
            else:
                if name == 'viewBox':
                    return value == size
            return False
        return _allow_svg


# -- filter

def clean(**kwargs):  # type: (**dict) -> 'function'
    r"""Returns sanitized value except allowed tags and attributes.

    It looks like `${'<a href="/"><em>link</em></a>'|n,clean(
    tags=['a'], attributes=['href'])}`.

    >>> from tirol.util import clean

    >>> type(clean(tags=['a'], attributes=['href']))
    <type 'function'>

    >>> c = clean(tags=['a'], attributes=['href'])
    >>> str(c('<a href="/"><em>link</em></a>'))
    '<a href="/">&lt;em&gt;link&lt;/em&gt;</a>'
    """
    def __clean(text):  # type: (str) -> Markup
        return Markup(_clean(text, **kwargs))

    return __clean
