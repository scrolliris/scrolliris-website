""" Timeline view unit tests.
"""
import pytest


@pytest.fixture(autouse=True)
def setup(config):  # pylint: disable=unused-argument
    """ Setup hook.
    """
    pass


def test_view_timeline(dummy_request):
    """ Test timeline.
    """
    from tirol import timeline

    res = timeline(dummy_request)
    assert dict == type(res)
