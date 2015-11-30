.DEFAULT_GOAL := test

.PHONY: requirements test

requirements:
	pip install -r requirements.txt

test:
	# Remove any existing data
	rm -rf repo_name

	# Create a new project with the default values
	cookiecutter . --no-input

	virtualenv repo_name/.venv

	# Execute the project's tests
	. repo_name/.venv/bin/activate && cd repo_name && make local-requirements
	. repo_name/.venv/bin/activate && cd repo_name && python manage.py makemigrations
	. repo_name/.venv/bin/activate && cd repo_name && make migrate
	. repo_name/.venv/bin/activate && cd repo_name && make validate

	# Ensure translations can be compiled
	. repo_name/.venv/bin/activate && cd repo_name && make fake_translations

	# Ensure documentation can be compiled
	. repo_name/.venv/bin/activate && cd repo_name/docs && make html
