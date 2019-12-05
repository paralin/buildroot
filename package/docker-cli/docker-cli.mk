################################################################################
#
# docker-cli
#
################################################################################

DOCKER_CLI_VERSION = 19.03.8
DOCKER_CLI_SITE = $(call github,docker,cli,v$(DOCKER_CLI_VERSION))
DOCKER_CLI_WORKSPACE = gopath

DOCKER_CLI_LICENSE = Apache-2.0
DOCKER_CLI_LICENSE_FILES = LICENSE

DOCKER_CLI_DEPENDENCIES = host-pkgconf

DOCKER_CLI_GOMOD = github.com/docker/cli
DOCKER_CLI_LDFLAGS = \
	-X $(DOCKER_CLI_GOMOD).GitCommit=$(DOCKER_CLI_VERSION) \
	-X $(DOCKER_CLI_GOMOD).Version=$(DOCKER_CLI_VERSION)

DOCKER_CLI_BUILD_TARGETS = $(DOCKER_CLI_GOMOD)/cmd/docker
DOCKER_CLI_TAGS = autogen

ifeq ($(BR2_PACKAGE_DOCKER_CLI_STATIC),y)
DOCKER_CLI_LDFLAGS += -extldflags '-static'
DOCKER_CLI_TAGS += osusergo netgo
DOCKER_CLI_GO_ENV = CGO_ENABLED=no
endif

DOCKER_CLI_INSTALL_BINS = $(notdir $(DOCKER_CLI_BUILD_TARGETS))

$(eval $(golang-package))
