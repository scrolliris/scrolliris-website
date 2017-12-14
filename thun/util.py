import json
from os import path
import re

from bleach import clean as _clean
from markupsafe import Markup
from pyramid.decorator import reify
from pyramid.events import subscriber
from pyramid.events import BeforeRender

from thun.env import Env

UNSLASH_PATTERN = re.compile(r'^\/|\/$')


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

    evt['svg_content'] = svg_content
    evt['svg_content_sanitized'] = svg_content_sanitized


class TemplateUtility(object):
    # pylint: disable=no-self-use

    def __init__(self, ctx, req, **kwargs):
        self.context, self.req = ctx, req

        self.env = Env()

        if getattr(req, 'util', None) is None:
            req.util = self
        self.__dict__.update(kwargs)

    @reify
    def manifest_json(self):  # type: () -> dict
        manifest_file = path.join(self.project_root, 'static', 'manifest.json')
        data = {}
        if path.isfile(manifest_file):
            with open(manifest_file) as data_file:
                data = json.load(data_file)

        return data

    @reify
    def project_root(self):  # type: () -> None
        return path.join(path.dirname(__file__), '..')

    @reify
    def var(self):  # type: () -> dict
        """Returns a dict has variables."""
        return {  # external services
            'gitlab_url': self.env.get('GITLAB_URL', '/'),
            'tinyletter_url': self.env.get('TINYLETTER_URL', '/'),
            'twitter_url': self.env.get('TWITTER_URL', '/'),
            'typekit_id': self.env.get('TYPEKIT_ID', ''),
            'userlike_script': self.env.get('USERLIKE_SCRIPT', '/'),
        }

    def is_matched(self, matchdict):  # type: (dict) -> bool
        return self.req.matchdict == matchdict

    def static_url(self, filepath):  # type: (str) -> str
        from thun.route import STATIC_DIR

        def get_bucket_info(name):
            part = self.req.settings.get('bucket.{0:s}'.format(name))
            if not part:
                # returns invalid path
                return ''
            return re.sub(UNSLASH_PATTERN, '', part)

        if self.env.is_production:
            h, n, p = [get_bucket_info(x) for x in ('host', 'name', 'path')]
            return 'https://{0:s}/{1:s}/{2:s}/{3:s}'.format(h, n, p, filepath)
        return self.req.static_url(STATIC_DIR + '/' + filepath)

    def static_path(self, filepath):  # type: (str) -> str
        from thun.route import STATIC_DIR
        return self.req.static_path(STATIC_DIR + '/' + filepath)

    def hashed_asset_url(self, filepath):  # type: (str) -> str
        hashed_filepath = self.manifest_json.get(filepath, filepath)
        return self.static_url(hashed_filepath)

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


def svg_content(svg_file):  # type: (str) -> str
    # img/FILE.[hash].svg
    svg_path = path.join(
        path.dirname(__file__), '..', 'static', svg_file)

    content = ''
    try:
        with open(svg_path, 'r') as f:
            content = f.read()
    except IOError:
        return ''
    return content


def svg_content_sanitized(svg_file, **kwargs):  # type: (str, dict) -> str
    r"""Rescues broken svg tags built by html5lib via bleach.clean.

    Apply `clean()`, but this rescures broken svg tags which built by html5lib.
    `clean()` returns broken tags. Many unnecessary `</path>` are added and
    slash in `<path />` are ommited :(

    >>> from markupsafe import Markup
    >>> from thun.util import svg_content_sanitized

    This returns string like object such as `Markup(u'')`. It will be used in
    template as string.

    >>> str(svg_content_sanitized('bundle.svg', tags=['symbol', 'defs', 'path'
    ... ], attributes={'path': ['id', 'd', 'transform']}))
    ''
    """
    content = svg_content(svg_file)
    clean_fn = clean(**kwargs)
    result = clean_fn(content)
    result = re.sub(r'\</path\>', '', result)
    result = re.sub(r'(\<path[A-z\s=\"-\.0-9]*")(\s*\>)', "\\1/\\2", result)
    return result


# -- filter

def clean(**kwargs):  # type: (**dict) -> 'function'
    r"""Returns sanitized value except allowed tags and attributes.

    It looks like `${'<a href="/"><em>link</em></a>'|n,clean(
    tags=['a'], attributes=['href'])}`.

    >>> import types
    >>> from thun.util import clean

    >>> isinstance(clean(tags=['a'], attributes=['href']), types.FunctionType)
    True
    >>> clean(tags=['a'], attributes=['href']).__name__
    '__clean'

    >>> c = clean(tags=['a'], attributes=['href'])
    >>> str(c('<a href="/"><em>link</em></a>'))
    '<a href="/">&lt;em&gt;link&lt;/em&gt;</a>'
    """
    def __clean(text):  # type: (str) -> Markup
        return Markup(_clean(text, **kwargs))
    return __clean
