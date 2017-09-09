ifeq (, $(ENV))
	extra := development
else ifeq (test, $(ENV))
	extra := testing
else
	extra := $(ENV)
endif

ifeq (test, $(ENV))
	section := main
else
	section := tirol
endif

# installation

setup:
	pip install -e '.[${extra}]' -c constraints.txt
.PHONY: setup

# server

serve:
	./bin/serve --env development --config config/${extra}.ini --reload
.PHONY: serve

# testing

test:
	ENV=test py.test -c 'config/testing.ini' -s -q
.PHONY: test

test-coverage:
	ENV=test py.test -c 'config/testing.ini' -s -q --cov=tirol --cov-report \
	  term-missing:skip-covered
.PHONY: test-coverage

coverage: | test-coverage
.PHONY: coverage

# translation

catalog-compile:
	./bin/linguine compile message en
.PHONY: catalog-compile

catalog-extract:
	./bin/linguine extract message
.PHONY: catalog-extract

catalog-update:
	./bin/linguine update message en
.PHONY: catalog-update

catalog: | catalog-compile
.PHONY: catalog

# utilities

check:
	flake8
.PHONY: check

lint:
	pylint tirol
	pylint tests
.PHONY: lint

clean:
	find . ! -readable -prune -o -print \
		! -path "./.git/*" ! -path "./node_modules/*" ! -path "./venv*" \
		! -path "./doc/*"  ! -path "./locale/*" \
		! -path "./build-output*" | \
	  grep -E "(__pycache__|\.egg-info|\.pyc|\.pyo)" | xargs rm -rf;
ifneq (, $(shell which gulp 2>/dev/null))
	gulp clean
endif
.PHONY: clean

.DEFAULT_GOAL = coverage
default: coverage
