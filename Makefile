VERSION:=$(shell ./aws-assume -v);
ACTION_HELP := github-action-help
ACTION_INSTALL := github-action-install

install:
	./install.sh

test:
	@echo ""
	@echo ""
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
	./aws-assume cp-public-key help
	@echo ""
	@echo ""
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
	./aws-assume upload-public-key help
	@echo ""
	@echo ""
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
	./aws-assume get-ssh-config help
	@echo ""
	@echo ""
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
	./aws-assume temp-creds help
	@echo ""
	@echo ""
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
	./aws-assume open help
	@echo ""
	@echo ""
	@echo "~~~~~~~~~~~~~~~~~~~~~~~~~"
	./aws-assume help

#test within docker
test-docker: test-action-install test-action-help

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

push-tag:
	git tag ${VERSION}
	git push --tags
