SED = sed
GIT = git

PACKAGE = rgwadmin
VERSION = $(shell git describe --abbrev=0 --tags)
OS_MAJOR_VERSION = $(shell lsb_release -rs | cut -f1 -d.)
OS := rhel$(OS_MAJOR_VERSION)
DIST_DIR := dist/$(OS)

PYTHON = python

REQUIRES := $(PYTHON),$(PYTHON)-requests,$(PYTHON)-requests-aws

.PHONY: rpm
rpm:
	-mkdir -p $(DIST_DIR)
	$(PYTHON) setup.py bdist_rpm \
			--python=$(PYTHON) \
			--requires="$(REQUIRES)" \
			--dist-dir=$(DIST_DIR) \
			--binary-only

.PHONY: sdist
sdist:
	python setup.py sdist

.PHONY: tag
tag:
	$(SED) -i 's/__version__ = .*/__version__ = "$(VERSION)"/g' $(PACKAGE)/__init__.py
	$(GIT) add $(PACKAGE)/__init__.py
	$(GIT) commit -m "Tagging $(VERSION)"
	$(GIT) tag -a $(VERSION) -m "Tagging $(VERSION)"

.PHONY: clean
clean:
	rm -rf dist/
