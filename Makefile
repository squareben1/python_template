.PHONY: install local lint flake8 black black-fix bandit safety test build docs

.ONESHELL:
install:
	poetry install

.ONESHELL:
update:
	poetry update

local: install
	poetry run pre-commit install

.ONESHELL: #local
lint: flake8 black

.ONESHELL:
flake8: #local
	poetry run flake8

.ONESHELL:
black: #local
	poetry run black --diff --check .

.ONESHELL:
black-fix: #local
	poetry run black .

.ONESHELL:
bandit: #local
	poetry run bandit -r --ini .bandit -q -n 3

.ONESHELL:
safety: #local
	poetry export -f requirements.txt | poetry run safety check --stdin

.ONESHELL:
test: #local
	PYTHONPATH=snake_hands/ \
		poetry run pytest \
		--cov-report term:skip-covered \
		--cov-report html:reports \
		--junitxml=reports/unit_test_coverage.xml \
		--cov=snake_hands tests/ -ra -s

.ONESHELL: #local
types: mypy

.ONESHELL:
mypy: #local
	poetry run mypy 

.ONESHELL:
build: #local
	poetry build

docs:
	poetry run pdoc --html snake_hands --force --output-dir docs
