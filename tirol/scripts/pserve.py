import sys

from tirol.env import Env


def main(argv=sys.argv, quiet=False):
    """Run original pserve with .env support
    """
    # `pserve` uses `hupper`, `hupper` has dependency **fcntl**.
    # In some environment (e.g. app engine), fcntl is not found :'(
    from pyramid.scripts.pserve import PServeCommand

    Env.load_dotenv_vars()

    command = PServeCommand(argv, quiet=quiet)
    return command.run()


if __name__ == '__main__':
    sys.exit(main() or 0)
