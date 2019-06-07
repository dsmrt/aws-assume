ACTION_HELP := github-action-help
ACTION_INSTALL := github-action-install

install:
	./install.sh

test: test-action-install test-action-help

build-action-install:
	docker build -t ${ACTION_INSTALL} actions/install

test-action-install: build-action-install
	docker run --rm \
	    -v ${PWD}:/github/workspace/ ${ACTION_INSTALL}

build-action-help:
	docker build -t ${ACTION_HELP} actions/help

test-action-help: build-action-help
	docker run --rm \
	    -v ${PWD}:/github/workspace/ ${ACTION_HELP}
