import os
import sys

from pyramid.paster import (
    get_app,
    setup_logging
)

from tirol.env import Env


def usage(argv):
    """Print pstart command usage
    """
    cmd = os.path.basename(argv[0])
    print('usage: %s <config_uri> [var=value]\n'
          '(example: "%s {staging|production}.ini")' % (cmd, cmd))
    sys.exit(1)


def main(argv=sys.argv, _quiet=False):
    """Starts main production server process
    """
    if len(argv) < 2:
        usage(argv)

    Env.load_dotenv_vars()
    env = Env()

    config_file = argv[1] if 1 in argv else 'config/production.ini'
    wsgi_app = get_app(config_file)
    setup_logging(config_file)

    from paste.script.cherrypy_server import cpwsgi_server
    return cpwsgi_server(wsgi_app, host=env.host, port=env.port,
                         numthreads=10, request_queue_size=100)


if __name__ == '__main__':
    sys.exit(main() or 0)
