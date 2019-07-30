

.DEFAULT_GOAL := help
.PHONY: help all clean distclean stop-containers clean-containers clean-images clean-volumes rebuild done clean-src local-src
HELP_COL_WIDTH=24


VIRTUALENV = $(HOME)/.virtualenvs/dev-skaro
LOCAL_SRC = src/django-authldap-utils src/django-eparch src/django-skaro-siteconf
LOCAL_SRC_FILES := $(shell find $(LOCAL_SRC) -name *.py -type f -print)
RSYNC_FLAGS = -au --delete-after --exclude .hg --exclude '*.evt' --exclude '*.pyc' --exclude build --exclude dist

BASE_IMAGE = skaro-base
BASE_IMAGE_TARGET = build/skaro-base.image
VOLUMES = skaro-media
VOLUME_TARGETS := $(addprefix build/,$(addsuffix .volume,$(IMAGES)))
IMAGES = skaro-web skaro-controller skaro-compute
IMAGE_TARGETS := $(addprefix build/,$(addsuffix .image,$(IMAGES)))

WEB = skaro-runserver
CONTROLLER = skaro-ctl
COMPUTE_NODES = skaro-n01 skaro-n02 skaro-n03 skaro-n04

CONTAINERS = $(WEB) $(CONTROLLER) $(COMPUTE_NODES)
WEB_TARGET := $(addprefix build/,$(addsuffix .container,$(WEB)))
CONTROLLER_TARGET := $(addprefix build/,$(addsuffix .container,$(CONTROLLER)))
COMPUTE_TARGETS := $(addprefix build/,$(addsuffix .container,$(COMPUTE_NODES)))
CONTAINER_TARGETS := $(addprefix build/,$(addsuffix .container,$(CONTAINERS)))



build/%.image: NAME = $(shell basename "$@" .image)
build/%.container: NAME = $(shell basename "$@" .container)
build/%.container: IMAGE = $(shell basename "$<" .image)
build/%.volume: NAME = $(shell basename "$@" .container)



help:	## Show this help message
	@grep -E '^\S+.*##.*' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-$(HELP_COL_WIDTH)s\033[0m %s\n", $$1, $$2}'


all: volumes containers done 	## Build all volumes, images, and containers and run them


volumes: $(VOLUME_TARGETS)	## Create volume(s)


containers: $(CONTAINER_TARGETS)	## Create and run container(s)


images: $(IMAGE_TARGETS)	## Create image(s)


$(LOCAL_SRC_FILES): %: $(VIRTUALENV)/%
	@echo "Updating code - changed files"
	cp $< $@


$(LOCAL_SRC): %: $(VIRTUALENV)/%
	@echo "Updating code - add or deleted files"
	@mkdir -p $(@D)
	rsync $(RSYNC_FLAGS) $</* $@/
	touch $@


local-src: $(LOCAL_SRC) $(LOCAL_SRC_FILES)


$(BASE_IMAGE_TARGET): build/%.image: %.dockerfile $(LOCAL_SRC) $(LOCAL_SRC_FILES)
	docker build -t $(NAME) -f "$<" .
	@mkdir -p $(@D)
	touch "$@"


$(IMAGE_TARGETS): build/%.image: %.dockerfile $(BASE_IMAGE_TARGET)
	docker build -t $(NAME) -f "$<" .
	@mkdir -p $(@D)
	touch "$@"


$(WEB_TARGET): build/%.container: build/skaro-web.image build/skaro-media.volume
	docker run --name $(NAME) -d --restart=always --link devdb:db00 --link math-ldap:ldap00 -p 8000:8000 --mount type=volume,src=skaro-media,dst=/var/lib/media $(IMAGE)
	@mkdir -p $(@D)
	touch "$@"


$(CONTROLLER_TARGET): build/%.container: build/skaro-controller.image
	docker run --name $(NAME) -d --restart=always --link devdb:db00 --link math-ldap:ldap00 $(IMAGE)
	@mkdir -p $(@D)
	touch "$@"


$(COMPUTE_TARGETS): build/%.container: build/skaro-compute.image build/skaro-media.volume
	docker run --name $(NAME) -d --restart=always --link devdb:db00 --link math-ldap:ldap00 --mount type=volume,src=skaro-media,dst=/var/lib/media $(IMAGE)
	@mkdir -p $(@D)
	touch "$@"


build/%.volume:
	docker volume create $(NAME)
	@mkdir -p $(@D)
	touch "$@"


clean: clean-images ## Stop and remove all skaro containers and images


clean-src:
	rm -rf src/*


distclean: clean clean-volumes clean-src	## Stop and remove all skaro containers, images, and volumes


stop-containers:	## Stop all running skaro containers
	for m in $$(docker ps --format '{{.Names}}\t{{.Image}}' | grep ^skaro- | cut -f 1); do docker stop "$$m" ; done


clean-containers: stop-containers	## Remove all skaro containers
	for m in $$(docker ps -a --format '{{.Names}}\t{{.Image}}' | grep ^skaro- | cut -f 1); do docker rm "$$m"; done
	rm -f build/*.container


clean-images: clean-containers	## Remove all skaro images
	for m in $$(docker images --format '{{.Repository}}' | grep skaro-); do docker rmi "$$m"; done
	rm -f build/*.image


clean-volumes: stop-containers
	for v in $$(docker volume ls --format '{{.Name}}' | grep skaro-); do docker volume rm "$$v"; done
	rm -f build/*.volume


rebuild: clean all	## Shortcut for clean then all


done:
	@./00_done_notify.sh "Docker build complete."
