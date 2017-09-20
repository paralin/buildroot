###############################################################################
#
# docker-cli
#
################################################################################

DOCKER_CLI_VERSION = v18.09.0-ce-beta1
DOCKER_CLI_SITE = $(call github,docker,cli,$(DOCKER_CLI_VERSION))
DOCKER_CLI_WORKSPACE = gopath

DOCKER_CLI_LICENSE = Apache-2.0
DOCKER_CLI_LICENSE_FILES = LICENSE

DOCKER_CLI_DEPENDENCIES = host-go host-pkgconf

DOCKER_CLI_LDFLAGS = \
	-X github.com/docker/cli/cli.GitCommit=$(DOCKER_CLI_VERSION) \
	-X github.com/docker/cli/cli.Version=$(DOCKER_CLI_VERSION)

ifeq ($(BR2_PACKAGE_DOCKER_CLI_STATIC),y)
DOCKER_CLI_LDFLAGS += -extldflags '-static'
endif

DOCKER_CLI_TAGS = cgo autogen
DOCKER_CLI_BUILD_TARGETS = cmd/docker

DOCKER_CLI_INSTALL_BINS = $(notdir $(DOCKER_CLI_BUILD_TARGETS))

$(eval $(golang-package))
