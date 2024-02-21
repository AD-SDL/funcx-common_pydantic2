COMPUTE_COMMON_VERSION=$(shell grep '^version =' setup.cfg | cut -d '=' -f2 | tr -d ' ')

.PHONY: lint test
lint:
	tox -e lint,mypy
test:
	tox

.PHONY: showvars prepare-release release
showvars:
	@echo "COMPUTE_COMMON_VERSION=$(COMPUTE_COMMON_VERSION)"
prepare-release:
	tox -e prepare-release -- --version "$(COMPUTE_COMMON_VERSION)"
	$(EDITOR) CHANGELOG.md
release:
	git tag -s "$(COMPUTE_COMMON_VERSION)" -m "v$(COMPUTE_COMMON_VERSION)"
	-git push $(shell git rev-parse --abbrev-ref @{push} | cut -d '/' -f1) refs/tags/$(COMPUTE_COMMON_VERSION)
	tox -e publish-release

.PHONY: clean
clean:
	rm -rf dist build *.egg-info .tox
