from __future__ import print_function
import os

from pyramid.decorator import reify


# OS's environ handler (wrapper)
# This class has utilities to treat environment variables.
class Env(object):
    VALUES = ('development', 'test', 'production')

    def __init__(self):
        v = str(os.environ.get('ENV', None))
        self._value = v if v in self.VALUES else 'production'

    @classmethod
    def load_dotenv_vars(cls, dotenv_file=None):
        # loads .env
        if dotenv_file is None:
            dotenv_file = os.path.join(os.getcwd(), '.env')
        if os.path.isfile(dotenv_file):
            print('loading environment variables from .env')
            from dotenv import load_dotenv
            load_dotenv(dotenv_file)

        if os.environ.get('ENV', None) == 'test':  # maps test_
            from test import test_vars

            for v in test_vars():
                test_v = os.environ.get('TEST_' + v, None)
                if test_v is not None:
                    os.environ[v] = test_v

    @staticmethod
    def settings_mappings():
        return {
            # Note: these values are updated if exist but not empty
            'storage.bucket_host': 'STORAGE_BUCKET_HOST',
            'storage.bucket_name': 'STORAGE_BUCKET_NAME',
            'storage.bucket_path': 'STORAGE_BUCKET_PATH',
            'wsgi.url_scheme': 'WSGI_URL_SCHEME',
        }

    def get(self, key, default=None):  # pylint: disable=no-self-use
        return os.environ.get(key, default)

    def set(self, key, value):  # pylint: disable=no-self-use
        os.environ[key] = value

    @reify
    def host(self):
        # TODO
        # get host and port from server section in ini as fallback
        return str(self.get('HOST', '127.0.0.1'))

    @reify
    def port(self):
        return int(self.get('PORT', 5000))

    @reify
    def value(self):
        return self._value

    @reify
    def is_test(self):
        return self._value == 'test'

    @reify
    def is_production(self):
        return self._value == 'production'
