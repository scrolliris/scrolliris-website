""" Roadmap view unit tests.
"""
import pytest


@pytest.fixture(autouse=True)
def setup(config):  # pylint: disable=unused-argument
    """ Setup hook.
    """
    pass


def test_view_roadmap(dummy_request):
    """ Test roadmap.
    """
    from tirol import roadmap

    res = roadmap(dummy_request)
    assert dict == type(res)
