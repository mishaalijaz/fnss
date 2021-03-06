SHELL = /bin/sh

BUILD_DIR = build
DIST_DIR  = dist
TEST_DIR  = test
DOC_DIR   = doc

.PHONY: clean dist doc test install upload distclean docclean

all: install

# Run all test cases
test:
	cd $(TEST_DIR); python test.py

# Build HTML documentation
doc: docclean
	make -C $(DOC_DIR) html

# Create distribution package
dist: clean doc
	python setup.py sdist

# Install the library in development mode
install: clean
	pip install --upgrade pip setuptools
	pip install --upgrade -r requirements.txt
	pip install --upgrade -e .

# Upload FNSS to Python Package Index (you need PyPI credentials on your machine)
upload: clean doc
	python setup.py sdist bdist_wheel upload

# Upload documentation to FNSS website (requires write permission to fnss/fnss.github.io)
docupload:
	make -C $(DOC_DIR) upload

# Clean documentation
docclean:
	make -C $(DOC_DIR) clean

# Clean dist files
distclean:
	rm -rf fnss.egg-info
	rm -rf $(DIST_DIR)

# Delete temp and build files
clean: docclean distclean
	find . -name "*__pycache__" | xargs rm -rf
	find . -name "*.pyc" | xargs rm -rf
	rm -rf $(BUILD_DIR) MANIFEST
