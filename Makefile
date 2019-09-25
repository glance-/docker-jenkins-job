VERSION=latest
NAME=jenkins-job
DOCKERFILE=Dockerfile
# This is used with so many different names...
NAMES=docker.sunet.se/$(NAME):$(VERSION) docker.sunet.se/sunet/$(NAME):$(VERSION) docker.sunet.se/sunet/docker-$(NAME):$(VERSION)
TAGGINGS=$(foreach name,$(NAMES),-t $(name))
NO_CACHE=--no-cache=false
# Subprojects
EXTRA_JOBS=$(patsubst %/$(DOCKERFILE),%,$(wildcard */$(DOCKERFILE)))

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

docker-jenkins-%-job:
	$(eval extra_job=$(patsubst docker-jenkins-%-job,%,$@))
	docker build -f $(extra_job)/$(DOCKERFILE) $(NO_CACHE) -t docker.sunet.se/sunet/$@ $(extra_job)
	-[ "$(extra_job)" = "xenial" ] && docker tag docker.sunet.se/sunet/$@ sunet/docker-jenkins-job-xenial

build_extra_jobs: $(foreach extra_job,$(EXTRA_JOBS),docker-jenkins-$(extra_job)-job)

update_extra_jobs: NO_CACHE=
update_extra_jobs: build_extra_jobs

push_docker-jenkins-%-job:
	docker push docker.sunet.se/sunet/$(patsubst push_%,%,$@)

push_extra_jobs: $(foreach extra_job,$(EXTRA_JOBS),push_docker-jenkins-$(extra_job)-job)
