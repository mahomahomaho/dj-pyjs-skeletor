MANAGE=python manage.py
PROJECT_NAME=project
SETTINGS=--settings=$(PROJECT_NAME).settings.test
PYJSBUILD=~/git/pyjs/bin/pyjsbuild
PYJSPATH=~/workspace2/monthdelta:~/ve/pyjamas/local/lib/python2.7/site-packages


FLAKE8_OPTS=--exclude=.git,migrations --max-complexity=10

.PHONY: all test coverage clean requirements update \
	ensure_virtualenv reqs/dev reqs/test reqs/prod dev-setup

all: coverage

test:
	$(MANAGE) test --where=. $(SETTINGS) --with-xunit

coverage:
	$(MANAGE) test --where=. $(SETTINGS) \
		--with-xcoverage --with-xunit --cover-html  --cover-erase

clean:
	rm -rf $(PROJECT_NAME)/staticfiles/output
	rm -rf .coverage cover nosetests.xml coverage.xml
	rm -rf $(PROJECT_NAME)/static/CACHE
	find . -name '*.pyc' -exec rm '{}' ';'

lint:
	flake8 $(FLAKE8_OPTS) .

ensure_virtualenv:
	@if [ -z $$VIRTUAL_ENV ]; then \
		echo "Please run me inside virtualenv.";  \
		exit 1; \
	fi

reqs/dev: ensure_virtualenv
	pip install -r requirements/dev.txt

reqs/test: ensure_virtualenv
	pip install -r requirements/test.txt

reqs/prod: ensure_virtualenv
	pip install -r requirements/prod.txt

dev-setup: ensure_virtualenv reqs/dev
	if [ ! -f $(PROJECT_NAME)/settings/local.py ]; then \
		echo 'from .dev import *' > $(PROJECT_NAME)/settings/local.py; \
	fi
	$(MANAGE) syncdb --all
	$(MANAGE) migrate --fake

test-setup: ensure_virtualenv reqs/test

dev-update: ensure_virtualenv reqs/dev
	$(MAKE) update

prod-update: ensure_virtualenv reqs/prod
	$(MAKE) update

update: ensure_virtualenv
	$(MAKE) clean
	$(MANAGE) syncdb
	$(MANAGE) migrate
	$(MANAGE) collectstatic --noinput

pyjs-prod:
	cd $(PROJECT_NAME)/pyjs && $(PYJSBUILD) --disable-compile-inplace --enable-signatures -o ../staticfiles/output main


pyjs-debug:
	cd $(PROJECT_NAME)/pyjs && $(PYJSBUILD) -d  --disable-compile-inplace --enable-signatures -o ../staticfiles/output main


