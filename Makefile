REGISTRY_HOST=docker.io
NAMESPACE=cblecker
IMAGE=arkse

RUNARGS=

default: build

build:
	docker build --ulimit nofile=90000:90000 -t $(REGISTRY_HOST)/$(NAMESPACE)/$(IMAGE):latest .

push:
	@hack/docker_push.sh $(REGISTRY_HOST)/$(NAMESPACE)/$(IMAGE):latest

run: build
	docker run -d $(RUNARGS) $(REGISTRY_HOST)/$(NAMESPACE)/$(IMAGE):latest

.PHONY: build push run
