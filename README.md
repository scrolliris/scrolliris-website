# Tirol

`/təɾóul/`

[![build status](https://gitlab.com/lupine-software/tirol/badges/master/build.svg)](
https://gitlab.com/lupine-software/tirol/commits/master) [![coverage report](
https://gitlab.com/lupine-software/tirol/badges/master/coverage.svg)](
https://gitlab.com/lupine-software/tirol/commits/master)

![Scrolliris](https://gitlab.com/lupine-software/tirol/raw/master/tirol/assets/img/scrolliris-logo-300x300.png)

```txt
 ______             _
(_) |o             | |
    |    ,_    __  | |
  _ ||  /  |  /  \_|/
 (_/ |_/   |_/\__/ |__/

Tirol; The IntROduction website for scrollIris
```

The website of [https://about.scrolliris.com/](https://about.scrolliris.com/).


## Requirements

* Python `3.5.4` (or `>= 2.7.13`)
* Node.js `7.10.1` (npm `5.4.1`, for build assets)
* Raleway Thin (for logo, use `bin/font-fetch.sh`)
* GNU gettext `>= 0.19.8.1` (translation)
* [Innsbruck](https://gitlab.com/lupine-software/innsbruck) as git subtree


## Integrations

* GitLab
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
(venv) % nodeenv --python-virtualenv --with-npm --node=7.10.1
: re-activate for node.js at this time
(venv) % source venv/bin/activate
(venv) % npm update --global npm@5.4.1
(venv) % npm --version
5.4.1
```

### Dependencies

#### Innsbruck

See translation project [Innsbruck](
https://gitlab.com/lupine-software/innsbruck).

Don't commit directly the changes on above translation project into this repo.

```zsh
: setup `locale`
% git remote add innsbruck https://gitlab.com/lupine-software/innsbruck.git
% git subtree add --prefix locale innsbruck master

: synchronize with updates into specified branch
% git pull -s subtree -Xsubtree=locale innsbruck master

: subtree list
% git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq
```

#### Raleway Thin

TODO



## Development

Use `waitress` as wsgi server.  
See `Makefile`.

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

### Style & Lint

* flake8
* pylint

```zsh
: add hook
(venv) % flake8 --install-hook git
(venv) % make style
```


## Deployment

Use `CherryPy` as wsgi server.

```zsh
: run install and start server for production
(venv) % ENV=production make setup

: or start server by yourself
(venv) % ./bin/serve --env production --config config/production.ini --install
```

### Publishing

E.g. Google App Engine

```zsh
: take latest sdk from https://cloud.google.com/sdk/downloads
% cd lib
(venv) % curl -sLO https://dl.google.com/dl/cloudsdk/channels/rapid/ \
  downloads/google-cloud-sdk-<VERSION>-linux-x86_64.tar.gz

: check sha256 checksum
(venv) % echo "<CHECKSUM>" "" ./google-cloud-sdk-<VERSION>-linux-x86_64.tar.gz \
  | sha256sum -c -
./google-cloud-sdk-<VERSION>-linux-x86_64.tar.gz: OK
(venv) % tar zxvf google-cloud-sdk-<VERSION>-linux-x86_64.tar.gz

: setup lib/ as a root for sdk
(venv) % CLOUDSDK_ROOT_DIR=. ./google-cloud-sdk/install.sh
(venv) % cd ../

: load sdk tools
(venv) % source ./bin/load-gcloud
(venv) % gcloud init
```

```zsh
: publish website
(venv) % source ./bin/load-gcloud
(venv) % gcloud app deploy ./app.yaml --project <project-id> --verbosity=info
```


## Testing

```zsh
(venv) % make test
```

### CI

You can check it by yourself using `gitlab-ci-multi-runner` on locale machine.
It requires `docker`.

```zsh
% ./bin/setup-gitlab-ci-multi-runner

: use script
% ./bin/ci-runner test
```

#### Links

See documents.

* https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/issues/312
* https://docs.gitlab.com/runner/install/linux-manually.html


## Documentation

TODO


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

0. extract
1. generate
2. update
3. compile


## License

Tirol; Copyright (c) 2017 Lupine Software LLC

This is free software;  
You can redistribute it and/or modify it under the terms of the
GNU Affero General Public License (AGPL).

See [LICENSE](LICENSE).
