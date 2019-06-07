ACTION_HELP := github-action-help

build-action-help:
	docker build -t ${ACTION_HELP} actions/help

test-action-help: build-action-help
	docker run --rm -it \
	    -v ${PWD}:/github/workspace/ ${ACTION_HELP}
