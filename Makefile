VERSION=latest
NAME=jenkins-job
DOCKERFILE=Dockerfile
# This is used with so many different names...
NAMES=docker.sunet.se/sunet/docker-$(NAME)\:$(VERSION)
TAGGINGS=$(foreach name,$(NAMES),-t $(name))
NO_CACHE=--no-cache=false
# Subprojects
EXTRA_JOBS=$(patsubst %/$(DOCKERFILE),%,$(wildcard */$(DOCKERFILE)))
PULL=

all: build push
all_extra_job: build push build_extra_jobs push_extra_jobs
all_extra_job_docker_wrapper: update update_extra_jobs
	@# trick to have make "redo" all the targets
	$(MAKE) update_docker_wrapper update_extra_jobs_docker_wrapper

pull:
	$(eval PULL=--pull)

build:
	docker build $(PULL) -f $(DOCKERFILE) $(NO_CACHE) $(TAGGINGS) .

build_docker_wrapper: DOCKERFILE=Dockerfile.docker-push-wrapper
build_docker_wrapper: build

update: NO_CACHE=
update: build

update_docker_wrapper: DOCKERFILE=Dockerfile.docker-push-wrapper
update_docker_wrapper: update

# There's some directory search magic going on in make,
# thats why the part up to the first / is left here.
push_docker.sunet.se/%:
	@# Mangle the name to enable the odd pattern for job-xenial
	$(eval image_name=$(subst xenial-job,job-xenial,$@))
	docker push $(patsubst push_%,%,$(image_name))

push: $(foreach name,$(NAMES),push_$(name))

# SOURCE_IMAGE build-arg is to be able to overwrite docker with push wrapper
docker.sunet.se/%:
	@# Mangle the name to enable the odd pattern for job-xenial
	$(eval image_name=$(subst xenial-job,job-xenial,$@))
	@# first, remove any :version from the name,
	@# and then we can match out the "job-name"
	@# so we can use that to figure out which context directory to use
	$(eval extra_job=$(patsubst docker.sunet.se/sunet/docker-jenkins-%-job,%,$(patsubst %:$(lastword $(subst :, ,$@)),%,$@)))
	@# Trickery to be able to override DOCKERFILE for docker push wrapper
	$(eval job_dir=$(shell dirname $(extra_job)/$(DOCKERFILE)))
	docker build $(PULL) --build-arg SOURCE_IMAGE=$(image_name) -f $(extra_job)/$(DOCKERFILE) $(NO_CACHE) -t $(image_name) $(job_dir)

build_extra_jobs: $(foreach extra_job,$(EXTRA_JOBS),docker.sunet.se/sunet/docker-jenkins-$(extra_job)-job\:$(VERSION))

build_extra_jobs_docker_wrapper: DOCKERFILE=../Dockerfile.docker-push-wrapper
build_extra_jobs_docker_wrapper: build_extra_jobs

update_extra_jobs: NO_CACHE=
update_extra_jobs: build_extra_jobs

update_extra_jobs_docker_wrapper: DOCKERFILE=../Dockerfile.docker-push-wrapper
update_extra_jobs_docker_wrapper: update_extra_jobs

push_extra_jobs: $(foreach extra_job,$(EXTRA_JOBS),push_docker.sunet.se/sunet/docker-jenkins-$(extra_job)-job\:$(VERSION))
