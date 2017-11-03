import pytest


@pytest.fixture(autouse=True)
def setup(config):  # pylint: disable=unused-argument
    pass


def test_view_index(dummy_request):
    from tirol import index

    res = index(dummy_request)
    assert dict == type(res)
