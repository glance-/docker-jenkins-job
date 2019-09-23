VERSION=latest
NAME=jenkins-job
DOCKERFILE=Dockerfile
# This is used with so many different names...
NAMES=docker.sunet.se/$(NAME)\:$(VERSION) docker.sunet.se/sunet/$(NAME)\:$(VERSION) docker.sunet.se/sunet/docker-$(NAME)\:$(VERSION)
TAGGINGS=$(foreach name,$(NAMES),-t $(name))
NO_CACHE=--no-cache=false
# Subprojects
EXTRA_JOBS=$(patsubst %/$(DOCKERFILE),%,$(wildcard */$(DOCKERFILE)))

all: build push
build:
	docker build -f $(DOCKERFILE) $(NO_CACHE) $(TAGGINGS) .
update: NO_CACHE=
update: build
# There's some directory search magic going on in make,
# thats why the part up to the first / is left here.
push_docker.sunet.se/%:
	docker push $(patsubst push_%,%,$@)

push: $(foreach name,$(NAMES),push_$(name))

# SOURCE_IMAGE build-arg is to be able to overwrite docker with push wrapper
docker-jenkins-%-job:
	@# Mangle the name to enable the odd pattern for job-xenial
	$(eval image_name=$(subst xenial-job,job-xenial,$@))
	$(eval extra_job=$(patsubst docker-jenkins-%-job,%,$@))
	@# Trickery to be able to override DOCKERFILE for docker push wrapper
	$(eval job_dir=$(shell dirname $(extra_job)/$(DOCKERFILE)))
	docker build --build-arg SOURCE_IMAGE=$(image_name) -f $(extra_job)/$(DOCKERFILE) $(NO_CACHE) -t $(image_name) $(job_dir)

build_extra_jobs: $(foreach extra_job,$(EXTRA_JOBS),docker-jenkins-$(extra_job)-job)

update_extra_jobs: NO_CACHE=
update_extra_jobs: build_extra_jobs

push_docker-jenkins-%-job:
	docker push docker.sunet.se/sunet/$(patsubst push_%,%,$@)

push_extra_jobs: $(foreach extra_job,$(EXTRA_JOBS),push_docker-jenkins-$(extra_job)-job)
