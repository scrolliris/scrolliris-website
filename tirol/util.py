from bleach import clean as _clean
from markupsafe import Markup

from pyramid.events import subscriber
from pyramid.events import BeforeRender


@subscriber(BeforeRender)
def add_template_utilities(evt) -> None:
    """Adds template utilities`.
    """
    evt['clean'] = clean

def clean(**kwargs) -> 'function':
    """Returns sanitized value except allowed tags and attributes.

    >>> ${'<a href="/"><em>link</em></a>'|n,clean(
            tags=['a'], attributes=['href'])}
    "<a href=\"/\">link</a>"
    """
    def __clean(text) -> Markup:
        return Markup(_clean(text, **kwargs))

    return __clean
