# Tirol

`/təɾóul/`

[![build status](https://gitlab.com/lupine-software/tirol/badges/master/build.svg)](
https://gitlab.com/lupine-software/tirol/commits/master) [![coverage report](
https://gitlab.com/lupine-software/tirol/badges/master/coverage.svg)](
https://gitlab.com/lupine-software/tirol/commits/master)

![Scrolliris](https://gitlab.com/lupine-software/tirol/raw/master/static/img/scrolliris-logo-300x300.png)

```txt
 ______             _
(_) |o             | |
    |    ,_    __  | |
  _ ||  /  |  /  \_|/
 (_/ |_/   |_/\__/ |__/

Tirol; The IntROduction website for scrollIris
```

The website of [https://scrolliris.com/](https://scrolliris.com/).


## Requirements

* Python `3.5.0`
* Node.js `7.8.0` (build)
* Raleway Thin (for logo, use `bin/font-fetch.sh`)
* GNU gettext `>= 0.19.8.1` (translation)
* [Innsbruck](https://gitlab.com/lupine-software/innsbruck) as git subtree


## Integrations

* GitLab
* Sentry
* Tinyletter
* Twitter
* Typekit
* Userlike


## Setup

```zsh
: setup python environment (e.g. virtualenv)
% python3.5 -m venv venv
% source venv/bin/activate
(venv) % pip install --upgrade pip setuptools

: node.js (e.g. nodeenv)
(venv) % pip install nodeenv
(venv) % nodeenv --python-virtualenv --with-npm --node=7.8.0
: re-activate for node.js at this time
(venv) % source venv/bin/activate
(venv) % npm --version
5.3.0
```

### Development

Use `waitress` as wsgi server.  
Check `Makefile`.

```zsh
% cd /path/to/tirol
% source venv/bin/activate

: set env
(venv) % cp .env.sample .env

: install packages
(venv) % ENV=development make setup

: install node modules & run gulp task
(venv) % npm install --global gulp-cli
(venv) % npm install

(venv) % gulp

: run server
(venv) % make serve
```


## Deployment

### Serve

Use `CherryPy` as wsgi server.

```zsh
: run install and start server for production
(venv) % ENV=production make setup

: or start server by yourself
(venv) % ./bin/serve --env production --config config/production.ini --install
```

### Publish

At first, setup for production environment.

```zsh
: e.g. use google app engine
(venv) % curl -sLO https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-157.0.0-linux-x86_64.tar.gz

: check sha256 checksum
(venv) % sha256sum google-cloud-sdk-157.0.0-linux-x86_64.tar.gz
95b98fc696f38cd8b219b4ee9828737081f2b5b3bd07a3879b7b2a6a5349a73f  google-cloud-sdk-157.0.0-linux-x86_64.tar.gz

(venv) % tar zxvf google-cloud-sdk-157.0.0-linux-x86_64.tar.gz

: we don\'t install this global environment even if development
(venv) % CLOUDSDK_ROOT_DIR=. ./google-cloud-sdk/install.sh

: load sdk tools
(venv) % source ./bin/load-gcloud
(venv) % gcloud init
```

### Deployment

E.g. to publish to gcp (appengine)

```zsh
: deploy website
(venv) % source ./bin/load-gcloud
(venv) % gcloud app deploy ./app.yaml --project <project-id> --verbosity=info
```


## Style check & Lint

* flake8
* pylint

```zsh
: check with flake8 (alias `make style` is also available)
(venv) % make check-style
```


## CI

You can check it by yourself using `gitlab-ci-multi-runner` on locale machine.
It requires `docker`.

```zsh
% ./bin/setup-gitlab-ci-multi-runner

: use script
% ./bin/ci-runner test
```


## Translation

See `./bin/linguine --help` and translation project [repository](
https://gitlab.com/lupine-software/innsbruck)

### Generate new catalog

Generate `xxx.pot` file.

```zsh
: edit Makefile (see also `bin/linguine` script)
(venv) % make catalog-extract
```

### Update and Compile translation catalog

See `Makefile`.
The translation catalog needs GNU gettext.

```zsh
(venv) % make catalog-update

: alias `make catalog` is also available
(venv) % make catalog-compile
```

### Work-flow

0. (generate)
1. extract
2. update
3. compile


### Subtree

Don't commit changes of translation project into this repo.

```zsh
: setup
% git remote add innsbruck https://gitlab.com/lupine-software/innsbruck.git
% git subtree add --prefix locale innsbruck  master

: Is it correct way to manage it both?  # FIXME
% cd locale
% cp -R /path/to/innsbruck/.git .

: synchronize with updates into specified branch
% git pull -s subtree innsbruck master

: subtree list
% git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq
```


## License

Tirol; Copyright (c) 2017 Lupine Software LLC.


This is free software;  
You can redistribute it and/or modify it under the terms of the
GNU Affero General Public License (AGPL).

See [LICENSE](LICENSE).
