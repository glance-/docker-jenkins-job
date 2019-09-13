VERSION=latest
NAME=jenkins-job
DOCKERFILE=Dockerfile
# This is used with so many different names...
NAMES=docker.sunet.se/$(NAME):$(VERSION) docker.sunet.se/sunet/$(NAME):$(VERSION) docker.sunet.se/sunet/docker-$(NAME):$(VERSION)
TAGGINGS=$(foreach name,$(NAMES),-t $(name))

all: build push
build:
	docker build -f $(DOCKERFILE) --no-cache=false $(TAGGINGS) .
update:
	docker build -f $(DOCKERFILE) $(TAGGINGS) .
push:
	set -e ; \
	for name in $(NAMES) ; do \
		docker push $$name ; \
	done
