# Scrolliris Website

Code Name: `Thun /tu̠n/`

[![pipeline status][pipeline]][commit] [![coverage report][coverage]][commit]

[pipeline]: https://gitlab.com/scrolliris/scrolliris-website/badges/master/build.svg
[coverage]: https://gitlab.com/scrolliris/scrolliris-website/badges/master/coverage.svg
[commit]: https://gitlab.com/scrolliris/scrolliris-website/commits/master

![Scrolliris](thun/assets/img/scrolliris-logo-300x300.png)

```txt
 ______ _
(_) |  | |
    |  | |            _  _
  _ |  |/ \   |   |  / |/ |
 (_/   |   |_/ \_/|_/  |  |_/

Thun; The Honest introdUctioN of scrolliris
```

The website of [https://about.scrolliris.com/](https://about.scrolliris.com/).


## Repository

https://gitlab.com/scrolliris/scrolliris-website


## Requirements

* Python `3.5.4` (or `>= 2.7.13`)
* Node.js `>= 8.9.0` (npm `5.5.1`, for build assets)
* GNU gettext `>= 0.19.8.1` (translation)
* [Scrolliris Website Translation (Uttigen)](https://gitlab.com/scrolliris/scrolliris-website-translation) as git subtree


## Integrations

* Google Fonts
* GitLab
* Tinyletter
* Twitter
* Userlike


## Setup

```zsh
: setup python environment (e.g. virtualenv)
% python3.5 -m venv venv
% source venv/bin/activate
(venv) % pip install --upgrade pip setuptools

: node.js (e.g. nodeenv)
(venv) % pip install nodeenv
(venv) % nodeenv --python-virtualenv --with-npm --node=8.9.0
: re-activate for node.js at this time
(venv) % source venv/bin/activate
(venv) % npm install --global npm@5.5.1
(venv) % npm --version
5.5.1
```

### Dependencies

#### Uttigen

See translation project [Uttigen](
https://gitlab.com/scrolliris/uttigen).

Don't commit directly the changes on above translation project into this repo.

```zsh
: setup `locale`
% git remote add uttigen https://gitlab.com/scrolliris/uttigen.git
% git subtree add --prefix locale uttigen master

: synchronize with updates into specified branch
% git pull -s subtree -Xsubtree=locale uttigen master

: subtree list
% git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq
```

#### Raleway Thin

TODO



## Development

Use `waitress` as wsgi server.  
See `Makefile`.

```zsh
% cd /path/to/thun
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

### Style check & Lint

* flake8
* pylint

```zsh
: add hook
(venv) % flake8 --install-hook git

: run `vet:code` and `vet:lint`
(venv) % make vet
```


## Deployment

Use `CherryPy` as wsgi server.

```zsh
: run install and start server for production
(venv) % ENV=production make setup

: or start server by yourself
(venv) % ./bin/serve --env production --config config/production.ini --install
```

### Delivery

E.g. Google App Engine

```zsh
: this script install cloud sdk into `./lib` directory
(venv) % ./bin/setup-google-cloud-sdk
```

Above script is equivalent following steps.

```zsh
: take latest sdk from https://cloud.google.com/sdk/downloads
% cd lib
(venv) % curl -sLO https://dl.google.com/dl/cloudsdk/channels/rapid/ \
  downloads/google-cloud-sdk-<VERSION>-linux-x86_64.tar.gz

: check sha256 checksum
(venv) % echo "CHECKSUM" "" ./google-cloud-sdk-<VERSION>-linux-x86_64.tar.gz \
  | sha256sum -c -
./google-cloud-sdk-<VERSION>-linux-x86_64.tar.gz: OK
(venv) % tar zxvf google-cloud-sdk-<VERSION>-linux-x86_64.tar.gz

: setup lib/ as a root for sdk
(venv) % CLOUDSDK_ROOT_DIR=. ./google-cloud-sdk/install.sh
(venv) % cd ../
```

```zsh
: publish website (create `app.yaml`)
(venv) % source ./bin/load-gcloud
(venv) % gcloud app deploy ./app.yaml --project <project-id> --verbosity=info
```

E.g. Heroku

```zsh
(venv) % echo '3.6.X' >> ./runtime.txt
(venv) % git push heroku master
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
https://gitlab.com/scrolliris/uttigen)

### Generate new catalog

Generate `xxx.pot` file.

```zsh
: edit Makefile (see also `bin/linguine` script)
(venv) % make i18n:extract
```

### Update and Compile translation catalog

See `Makefile`.
The translation catalog needs GNU gettext.

```zsh
(venv) % make i18n:update

: alias `make i18n` is also available
(venv) % make i18n:compile
```

### Work-flow

0. extract
1. generate
2. update
3. compile


## License

This project is distributed as various licenses by parts.

```txt
Scrolliris Website
Copyright (c) 2017 Lupine Software LLC
```

### Documentation

`GFDL-1.3`

The files in the `thun/doc` directory are distributed as
GNU Free Documentation License. (version 1.3)

```txt
Permission is granted to copy, distribute and/or modify this document
under the terms of the GNU Free Documentation License, Version 1.3
or any later version published by the Free Software Foundation;
with no Invariant Sections, no Front-Cover Texts, and no Back-Cover Texts.
A copy of the license is included in the section entitled "GNU
Free Documentation License".
```

Check the [GNU Free Documentation License](
https://www.gnu.org/licenses/fdl-1.3.en.html).

### Resource (image)

`CC-BY-NC-SA-4.0`

The files in the `thun/assets/img` directory are licensed under the
Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
Public License.

[![Creative Commons License](
https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png)](
http://creativecommons.org/licenses/by-nc-sa/4.0/)

Check the [Legalcode](
https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode).

### Software (program)

`AGPL-3.0`

```txt
This is free software: You can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
```

See [LICENSE](LICENSE).
