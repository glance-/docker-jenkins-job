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

pull:
	$(eval PULL=--pull)

build:
	docker build -f $(DOCKERFILE) $(PULL) $(NO_CACHE) $(TAGGINGS) .

update: NO_CACHE=
update: build

clean:
	docker rmi $(NAMES)

# There's some directory search magic going on in make,
# thats why the part up to the first / is left here.
push_docker.sunet.se/%:
	@# Mangle the name to enable the odd pattern for job-xenial
	$(eval image_name=$(subst xenial-job,job-xenial,$(patsubst push_%,%,$@)))
	docker push $(image_name)

push: $(foreach name,$(NAMES),push_$(name))

docker.sunet.se/%:
	@# Mangle the name to enable the odd pattern for job-xenial
	$(eval image_name=$(subst xenial-job,job-xenial,$@))
	@# first, remove any :version from the name,
	@# and then we can match out the "job-name"
	@# so we can use that to figure out which context directory to use
	$(eval extra_job=$(patsubst docker.sunet.se/sunet/docker-jenkins-%-job,%,$(patsubst %:$(lastword $(subst :, ,$@)),%,$@)))
	docker build -f $(extra_job)/$(DOCKERFILE) $(PULL) $(NO_CACHE) -t $(image_name) $(extra_job)

build_extra_jobs: $(foreach extra_job,$(EXTRA_JOBS),docker.sunet.se/sunet/docker-jenkins-$(extra_job)-job\:$(VERSION))

update_extra_jobs: NO_CACHE=
update_extra_jobs: build_extra_jobs

push_extra_jobs: $(foreach extra_job,$(EXTRA_JOBS),push_docker.sunet.se/sunet/docker-jenkins-$(extra_job)-job\:$(VERSION))

clean_extra_jobs:
	docker rmi $(subst xenial-job,job-xenial,$(foreach extra_job,$(EXTRA_JOBS),docker.sunet.se/sunet/docker-jenkins-$(extra_job)-job\:$(VERSION)))
