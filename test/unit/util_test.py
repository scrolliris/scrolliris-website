import pytest

from tirol.util import TemplateUtility


@pytest.fixture(autouse=True)
def setup(config):  # pylint: disable=unused-argument
    pass


def test_req_util(dummy_request):
    util = TemplateUtility({}, dummy_request)
    assert dummy_request.util == util


def test_util_context(dummy_request):
    ctx = {'dummy_context': True}

    util = TemplateUtility(ctx, dummy_request)
    assert ctx == util.context


def test_manifest_json_content_if_missing(dummy_request, tmpdir, monkeypatch):
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
    assert expected == util.manifest_json
    assert 1 == path.isfile.call_count  # pylint: disable=no-member


def test_var_loading_env_var(dummy_request, monkeypatch, mocker):
    from tirol.env import Env

    expected = 'https://gitlab.com/scrolliris/tirol'
    monkeypatch.setenv('GITLAB_URL', expected)
    mocker.spy(Env, '__init__')

    util = TemplateUtility({}, dummy_request)
    assert expected == util.var['gitlab_url']
    assert 1 == Env.__init__.call_count  # pylint: disable=no-member
    # must be cached
    assert expected == util.var['gitlab_url']
    assert 1 == Env.__init__.call_count  # pylint: disable=no-member


def test_var_keys(dummy_request):
    util = TemplateUtility({}, dummy_request)
    expected = ['gitlab_url', 'tinyletter_url', 'twitter_url', 'typekit_id',
                'userlike_script']
    assert expected == sorted(list(util.var.keys()))


def test_is_matched(dummy_request):
    expected = {'foo': 'bar'}
    dummy_request.matchdict = {}
    util = TemplateUtility({}, dummy_request)
    assert not util.is_matched(expected)

    expected = {'foo': 'bar'}
    dummy_request.matchdict = expected
    util = TemplateUtility({}, dummy_request)
    assert util.is_matched(expected)


def test_is_static_url(config, dummy_request):
    from tirol.route import STATIC_DIR

    config.add_static_view(
        name='assets', path=STATIC_DIR, cache_max_age=0)

    util = TemplateUtility({}, dummy_request)
    assert 'http://example.com/assets/img/logo.png' == \
           util.static_url('img/logo.png')


def test_is_static_path(config, dummy_request):
    from tirol.route import STATIC_DIR

    config.add_static_view(
        name='assets', path=STATIC_DIR, cache_max_age=0)

    util = TemplateUtility({}, dummy_request)
    assert '/assets/img/logo.png' == \
           util.static_path('img/logo.png')


def test_hashed_asset_url(config, dummy_request, tmpdir, monkeypatch):
    from os import path
    from tirol.route import STATIC_DIR

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

    dummy_request.settings = {}

    util = TemplateUtility({}, dummy_request)
    assert 'http://example.com/assets/master.0.css' == \
           util.hashed_asset_url('master.css')


def test_hashed_asset_url_on_production_mode(
        config, dummy_request, tmpdir, monkeypatch):
    from os import path
    from collections import namedtuple
    from tirol.route import STATIC_DIR

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

    dummy_request.settings = {
        'storage.bucket_host': 'cdn.example.com',
        'storage.bucket_name': 'test-bucket',
        'storage.bucket_path': '/v1/static',
    }

    util = TemplateUtility({}, dummy_request)

    # pylint: disable=invalid-name
    DummyEnv = namedtuple('Env', 'is_production')
    util.env = DummyEnv(True)

    assert 'https://cdn.example.com/test-bucket/v1/static/master.0.css' == \
           util.hashed_asset_url('master.css')
