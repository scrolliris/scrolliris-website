import pytest


@pytest.fixture(autouse=True)
def setup(config):  # pylint: disable=unused-argument
    pass


def test_view_timeline(dummy_request):
    from thun import timeline

    res = timeline(dummy_request)
    assert dict == type(res)
