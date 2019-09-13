VERSION=latest
NAME=jenkins-job
DOCKERFILE=Dockerfile

all: build push
build:
	docker build -f $(DOCKERFILE) --no-cache=false -t $(NAME):$(VERSION) .
update:
	docker build -f $(DOCKERFILE) -t $(NAME):$(VERSION) .
push:
	docker tag $(NAME):$(VERSION) docker.sunet.se/$(NAME):$(VERSION)
	docker push docker.sunet.se/$(NAME):$(VERSION)
