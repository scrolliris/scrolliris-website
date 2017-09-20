import os

import pytest


# NOTE:
# The request variable in py.test is special context of testing.
# See http://doc.pytest.org/en/latest/fixture.html#request-context

# -- Shared fixtures

@pytest.fixture(scope='session')
def dotenv():
    from tirol.env import Env

    # same as tirol:main
    dotenv_file = os.path.join(os.getcwd(), '.env')
    Env.load_dotenv_vars(dotenv_file)

    return


@pytest.fixture(scope='session')
def env(dotenv):
    from tirol.env import Env
    return Env()


@pytest.fixture(scope='session')
def raw_settings(dotenv):
    from pyramid.paster import get_appsettings

    ini_file = os.path.join(os.getcwd(), 'config/testing.ini')
    return get_appsettings(ini_file)


@pytest.fixture(scope='session')
def resolve_settings():

    def _resolve_settings(raw_s):
        # pass
        return raw_s

    return _resolve_settings


@pytest.fixture(scope='session')
def settings(raw_settings, resolve_settings):
    return resolve_settings(raw_settings)


@pytest.fixture(scope='session')
def extra_environ(env):
    environ = {
        'SERVER_PORT': '80',
        'REMOTE_ADDR': '127.0.0.1',
        'wsgi.url_scheme': 'http',
    }
    return environ


# auto fixtures

@pytest.yield_fixture(autouse=True, scope='session')
def session_helper():
    yield


@pytest.yield_fixture(autouse=True, scope='module')
def module_helper(settings):
    yield


@pytest.yield_fixture(autouse=True, scope='function')
def function_helper():
    yield


# -- unit test

@pytest.fixture(scope='session')
def config(request, settings):
    from pyramid import testing

    config = testing.setUp(settings=settings)

    # FIXME:
    #    these includings from .ini file are not evaluated
    #    in unittest.
    # config.include('pyramid_mako')

    config.add_translation_dirs('tirol:../locale')

    from pyramid.events import BeforeRender, NewRequest
    from tirol import add_localizer, add_renderer_globals

    config.add_subscriber(add_localizer, NewRequest)
    config.add_subscriber(add_renderer_globals, BeforeRender)

    def teardown():
        testing.tearDown()

    request.addfinalizer(teardown)

    return config


@pytest.fixture(scope='function')
def dummy_request(extra_environ):
    from pyramid import testing
    from tirol import get_translator_function

    locale_name = 'en'
    req = testing.DummyRequest(
        subdomain='',
        environ=extra_environ,
        _LOCALE_=locale_name,
        locale_name=locale_name,
        matched_route=None)
    req.translate = get_translator_function(req.localizer)

    return req


# -- functional test

@pytest.fixture(scope='session')
def _app(raw_settings):
    from tirol import main
    global_config = {
        '__file__': raw_settings['__file__']
    }
    del raw_settings['__file__']

    return main(global_config, **raw_settings)


@pytest.fixture(scope='session')
def dummy_app(_app, extra_environ):
    from webtest import TestApp

    return TestApp(_app, extra_environ=extra_environ)
