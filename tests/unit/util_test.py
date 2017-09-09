"""Utility unit tests
"""
import pytest


@pytest.fixture(autouse=True)
def setup(config):  # pylint: disable=unused-argument
    """Setup hook
    """
    pass


def test_req_util(dummy_request):
    """Test req.util attribute
    """
    from tirol.util import TemplateUtility

    util = TemplateUtility({}, dummy_request)
    assert dummy_request.util == util


def test_util_context(dummy_request):
    """Test util.context attribute
    """
    from tirol.util import TemplateUtility

    ctx = {'dummy_context': True}

    util = TemplateUtility(ctx, dummy_request)
    assert ctx == util.context


def test_manifest_json_content_if_missing(dummy_request, tmpdir, monkeypatch):
    """Test util.manifest_json property if it does not exist
    """
    from tirol.util import TemplateUtility
    from os import path

    actual_path_dirname = path.dirname
    dummy_dir = tmpdir.mkdir('dummy')
    # create only path for manifest.json
    manifest_json = dummy_dir.mkdir('static').join('manifest.json')

    def dummy_dirname(_filepath):  # pylint: disable=missing-docstring
        return actual_path_dirname(str(manifest_json))

    monkeypatch.setattr(path, 'dirname', dummy_dirname)

    util = TemplateUtility({}, dummy_request)
    assert {} == util.manifest_json


def test_manifest_json_content(dummy_request, tmpdir, monkeypatch, mocker):
    """Test util.manifest_json property
    """
    from tirol.util import TemplateUtility
    from os import path

    actual_path_dirname = path.dirname
    dummy_dir = tmpdir.mkdir('dummy')
    # create test manifest.json in dummy directory
    manifest_json = dummy_dir.mkdir('static').join('manifest.json')
    manifest_json.write('''\
{
  "master.css": "master.123.css",
  "master.js": "master.456.js",
  "master.svg": "img/master.789.svg"
}\
''')

    def dummy_dirname(_filepath):  # pylint: disable=missing-docstring
        return actual_path_dirname(str(manifest_json))

    monkeypatch.setattr(path, 'dirname', dummy_dirname)
    mocker.spy(path, 'isfile')

    util = TemplateUtility({}, dummy_request)
    expected = {
        'master.css': 'master.123.css',
        'master.js': 'master.456.js',
        'master.svg': 'img/master.789.svg'
    }
    assert expected == util.manifest_json
    assert 1 == path.isfile.call_count  # pylint: disable=no-member
    # must be cached
    _ = util.manifest_json
    assert 1 == path.isfile.call_count  # pylint: disable=no-member


def test_var_loading_env_var(dummy_request, monkeypatch, mocker):
    """Test util.var property
    """
    from tirol.util import TemplateUtility
    from tirol.env import Env

    expected = 'https://gitlab.com/lupine-software/tirol'
    monkeypatch.setenv('GITLAB_URL', expected)
    mocker.spy(Env, '__init__')

    util = TemplateUtility({}, dummy_request)
    assert expected == util.var['gitlab_url']
    assert 1 == Env.__init__.call_count  # pylint: disable=no-member
    # must be cached
    _ = util.var
    assert 1 == Env.__init__.call_count  # pylint: disable=no-member


def test_var_keys(dummy_request):
    """Test util.var property
    """
    from tirol.util import TemplateUtility

    util = TemplateUtility({}, dummy_request)
    expected = ['gitlab_url', 'tinyletter_url', 'twitter_url', 'typekit_id',
                'userlike_script']
    assert expected == sorted(list(util.var.keys()))


def test_is_matched(dummy_request):
    """Test util.is_matched method
    """
    from tirol.util import TemplateUtility

    expected = {'foo': 'bar'}
    dummy_request.matchdict = {}
    util = TemplateUtility({}, dummy_request)
    assert not util.is_matched(expected)

    expected = {'foo': 'bar'}
    dummy_request.matchdict = expected
    util = TemplateUtility({}, dummy_request)
    assert util.is_matched(expected)


def test_is_static_url(config, dummy_request):
    """Test util.static_url method
    """
    from tirol.util import TemplateUtility
    from tirol import STATIC_DIR

    config.add_static_view(
        name='assets', path=STATIC_DIR, cache_max_age=0)

    util = TemplateUtility({}, dummy_request)
    assert 'http://example.com/assets/img/logo.png' == \
           util.static_url('img/logo.png')


def test_is_static_path(config, dummy_request):
    """Test util.static_path method
    """
    from tirol.util import TemplateUtility
    from tirol import STATIC_DIR

    config.add_static_view(
        name='assets', path=STATIC_DIR, cache_max_age=0)

    util = TemplateUtility({}, dummy_request)
    assert '/assets/img/logo.png' == \
           util.static_path('img/logo.png')


def test_built_asset_url(config, dummy_request, tmpdir, monkeypatch):
    """Test util.built_asset_url method
    """
    from os import path
    from tirol.util import TemplateUtility
    from tirol import STATIC_DIR

    config.add_static_view(
        name='assets', path=STATIC_DIR, cache_max_age=0)

    actual_path_dirname = path.dirname
    dummy_dir = tmpdir.mkdir('dummy')
    # create test manifest.json in dummy directory
    manifest_json = dummy_dir.mkdir('static').join('manifest.json')
    manifest_json.write('''\
{
  "master.css": "master.0.css"
}\
''')

    def dummy_dirname(_filepath):  # pylint: disable=missing-docstring
        return actual_path_dirname(str(manifest_json))

    monkeypatch.setattr(path, 'dirname', dummy_dirname)

    util = TemplateUtility({}, dummy_request)
    assert 'http://example.com/assets/master.0.css' == \
           util.built_asset_url('master.css')
