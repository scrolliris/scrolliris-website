""" Index view unit tests.
"""
import pytest


@pytest.fixture(autouse=True)
def setup(config):  # pylint: disable=unused-argument
    """ Setup hook.
    """
    pass


def test_view_index(dummy_request):
    """ Test index.
    """
    from tirol import index

    res = index(dummy_request)
    assert dict == type(res)
