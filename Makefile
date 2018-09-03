ifeq (, $(ENV))
	ENV := development
	env := development
else ifeq (test, $(ENV))
	env := testing
else
	env := $(ENV)
endif

ifeq (, $(NODE_ENV))
	NODE_ENV := development
endif

app = thun

.DEFAULT_GOAL = coverage
default: coverage


# -- setup

setup:  ## Install Python packages
	pip install -e '.[${env}]' -c constraints.txt
.PHONY: setup

setup\:force:  ## Install Python packages with `--force-reinstall`
	pip install --upgrade --force-reinstall -e '.[${env}]' -c constraints.txt
.PHONY: setup\:force

setup\:update:  ## Update Python packages
	pip install --upgrade -e '.[${env}]' -c constraints.txt
.PHONY: setup\:update


# -- serve

serve:  ## Run server process (development)
	./bin/serve --env development --config config/${env}.ini --reload
.PHONY: serve


# -- test

test:  ## Run unit tests
	ENV=test py.test -c 'config/testing.ini' -s -q
.PHONY: test

test\:doc:  ## Run doctest in Python code
	ENV=test ./bin/run_doctest
.PHONY: test\:doc

test\:coverage:  ## Run `test` with coverage outputs
	ENV=test py.test -c 'config/testing.ini' -s -q --cov=${app} --cov-report \
	  term-missing:skip-covered
.PHONY: test\:coverage


# -- i18n (translation)

i18n: | i18n\:compile  ## An alias of `i18n:compile`
.PHONY: i18n

i18n\:compile:  ## Make translation files (catalog)
	./bin/linguine compile message en
.PHONY: i18n\:compile

i18n\:extract:  ## Extract translation targets from code
	./bin/linguine extract message
.PHONY: i18n\:extract

i18n\:update:  ## Update catalog (pot)
	./bin/linguine update message en
.PHONY: i18n\:update

i18n\:sync:  ## Fetch translation updates from upstrm (scrolliris/scrolliris-website-translation)
	./bin/linguine sync
.PHONY: i18n\:sync


# -- vet

vet: | vet\:code vet\:lint  ## Run `vet:code` and `vet:lint` both (without vet:quality)
.PHONY: vet

vet\:code:  ## Check pycode code style (pycodestyle)
	pycodestyle --ignore=E402 test thun
	flake8
.PHONY: vet\:code

vet\:lint:  ## Lint python codes
	pylint test ${app}
.PHONY: vet\:lint


# -- utilities

pack:  ## Build assets using gulp-cli
ifeq (, $(shell which gulp 2>/dev/null))
	$(info gulp command not found. run `npm install -g gulp-cli`)
	$(info )
else
	NODE_ENV=$(NODE_ENV) gulp
endif
.PHONY: build

clean:  ## Delete unnecessary cache etc.
	find . ! -readable -prune -o -print \
	  ! -path "./.git/*" ! -path "./node_modules/*" ! -path "./venv*" \
	  ! -path "./doc/*" ! -path "./tmp/*" \
	  ! -path "./lib/*" | \
	  grep -E "(__pycache__|.*\.egg-info|\.pyc|\.pyo|\.mo)" | xargs rm -rf;
ifeq (, $(shell which gulp 2>/dev/null))
	$(info gulp command not found. run `npm install -g gulp-cli`)
	$(info )
else
	NODE_ENV=$(NODE_ENV) gulp clean
endif
.PHONY: clean

expose:  ## Print untracked (volatile) files
	git ls-files --others | \
	  grep -vE '(lib|tmp|test|static|db|locale|node_modules|\.?cache)/' | \
	  grep -vE '(__pycache__|\.egg-info|venv)/' | \
	  grep -vE '(\.coverage|\.*-version|bin\/gitlab*)'
.PHONY: expose

deploy:  ## Deploy app to production server
	./bin/plate $(ACTION) $(VERSION)
.PHONY: deploy

help:  ## Display this message
	@grep -E '^[0-9a-z\:\\]+: ' $(MAKEFILE_LIST) | grep -E '  ##' | \
	  sed -e 's/\(\s|\(\s[0-9a-z\:\\]*\)*\)  /  /' | tr -d \\\\ | \
	  awk 'BEGIN {FS = ":  ## "}; {printf "\033[36m%-14s\033[0m %s\n", $$1, $$2}' | \
	  sort
.PHONY: help
