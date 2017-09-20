ifeq (, $(ENV))
	env := development
else ifeq (test, $(ENV))
	env := testing
else
	env := $(ENV)
endif

# installation

setup:
	pip install -e '.[${env}]' -c constraints.txt
.PHONY: setup

# server

serve:
	./bin/serve --env development --config config/${env}.ini --reload
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

catalog-envct:
	./bin/linguine envct message
.PHONY: catalog-envct

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
	pylint test
.PHONY: lint

clean:
	find . ! -readable -prune -o -print \
	 ! -path "./.git/*" ! -path "./node_modules/*" ! -path "./venv*" \
	 ! -path "./doc/*" ! -path "./locale/*" ! -path "./tmp/*" \
	 ! -path "./lib/*" | \
	 grep -E "(__pycache__|.*\.egg-info|\.pyc|\.pyo)" | xargs rm -rf;
ifeq (, $(shell which gulp 2>/dev/null))
	$(info gulp command not found. run `npm install -g gulp-cli`)
	$(info )
else
	gulp clean
endif
.PHONY: clean

.DEFAULT_GOAL = coverage
default: coverage
