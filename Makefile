.DEFAULT_GOAL := help

IMAGE_NAME = mermaid-editor

BASE_PREFIX = vonsalza
TAG = 0.0.1
MAIN_PREFIX = $(BASE_PREFIX)/$(IMAGE_NAME)

all:
	$(MAKE) mle-run
	$(MAKE) nginx-build

clone: 
	git clone git@github.com:mermaidjs/mermaid-live-editor.git

mle-build: clone ## build mermaid live editor
	docker build -f mle-Dockerfile -t $(MAIN_PREFIX)-mle:$(TAG) .
mle-run: mle-build ## run container for mle build
	docker run --rm -it -v $(CURDIR)/mermaid-live-editor:/work/temp:rw $(MAIN_PREFIX)-mle:$(TAG)

nginx-build: ## build image
	docker build -f nginx-Dockerfile -t $(MAIN_PREFIX)-nginx:$(TAG) .

#push: build ## push image
#	docker push $(MAIN_PREFIX):$(TAG)

nginx-local-run: nginx-build ## run container
	docker run --rm -it -p 8080:80 $(MAIN_PREFIX)-nginx:$(TAG)
help: ## show this help
	echo IMAGE: $(MAIN_PREFIX):$(TAG)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
