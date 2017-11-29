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

# -- installation

setup:
	pip install -e '.[${env}]' -c constraints.txt
.PHONY: setup

setup-force:
	pip install --upgrade --force-reinstall -e '.[${env}]' -c constraints.txt
.PHONY: setup-force

update:
	pip install --upgrade -e '.[${env}]' -c constraints.txt
.PHONY: update

# -- application

serve:
	./bin/serve --env development --config config/${env}.ini --reload
.PHONY: serve

# -- testing

test:
	ENV=test py.test -c 'config/testing.ini' -s -q
.PHONY: test

doctest:
	ENV=test ./bin/run_doctest
.PHONY: doctest

coverage:
	ENV=test py.test -c 'config/testing.ini' -s -q --cov=${app} --cov-report \
	  term-missing:skip-covered
.PHONY: coverage

# -- translation

catalog-compile:
	./bin/linguine compile message en
	./bin/linguine compile timeline en
.PHONY: catalog-compile

catalog-extract:
	./bin/linguine extract message
.PHONY: catalog-extract

catalog-update:
	./bin/linguine update message en
	./bin/linguine update timeline en
.PHONY: catalog-update

catalog: | catalog-compile
.PHONY: catalog

# -- utility

check:
	flake8
.PHONY: check

lint:
	pylint test ${app}
.PHONY: lint

vet: | check lint
.PHONY: vet

build:
ifeq (, $(shell which gulp 2>/dev/null))
	$(info gulp command not found. run `npm install -g gulp-cli`)
	$(info )
else
	NODE_ENV=$(NODE_ENV) gulp
endif
.PHONY: build

clean:
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


.DEFAULT_GOAL = coverage
default: coverage
