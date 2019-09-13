VERSION=latest
NAME=jenkins-job
DOCKERFILE=Dockerfile

all: build push
build:
	docker build -f $(DOCKERFILE) --no-cache=false -t docker.sunet.se/$(NAME):$(VERSION) .
update:
	docker build -f $(DOCKERFILE) -t docker.sunet.se/$(NAME):$(VERSION) .
push:
	docker push docker.sunet.se/$(NAME):$(VERSION)
