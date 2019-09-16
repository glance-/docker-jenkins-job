VERSION=latest
NAME=jenkins-job
DOCKERFILE=Dockerfile
# This is used with so many different names...
NAMES=docker.sunet.se/$(NAME):$(VERSION) docker.sunet.se/sunet/$(NAME):$(VERSION) docker.sunet.se/sunet/docker-$(NAME):$(VERSION)
TAGGINGS=$(foreach name,$(NAMES),-t $(name))
NO_CACHE=--no-cache=false

all: build push
build:
	docker build -f $(DOCKERFILE) $(NO_CACHE) $(TAGGINGS) .
update: NO_CACHE=
update: build
push:
	set -e ; \
	for name in $(NAMES) ; do \
		docker push $$name ; \
	done
