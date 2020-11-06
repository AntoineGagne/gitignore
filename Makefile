image:
	docker build \
		--tag=$(DOCKER_USERNAME)/gitignore:$(VERSION) \
		--label branch=$(BRANCH) \
		--label commit=$(COMMIT) \
		--label version=$(VERSION) \
		--label build-date=$(shell date --iso-8601='seconds') \
		--file=Dockerfile .
