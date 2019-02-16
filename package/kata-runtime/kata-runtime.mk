################################################################################
#
# kata-runtime
#
################################################################################

KATA_RUNTIME_VERSION = 1.5.0
KATA_RUNTIME_SITE = $(call github,kata-containers,runtime,$(KATA_RUNTIME_VERSION))

KATA_RUNTIME_LICENSE = Apache-2.0
KATA_RUNTIME_LICENSE_FILES = LICENSE

KATA_RUNTIME_DEPENDENCIES = host-pkgconf

KATA_RUNTIME_LDFLAGS = \
	-X main.commit=$(KATA_RUNTIME_VERSION) \
	-X main.version=$(KATA_RUNTIME_VERSION)

KATA_RUNTIME_BUILD_TARGETS = cli
KATA_RUNTIME_BIN_NAME = kata-runtime
KATA_RUNTIME_INSTALL_BINS = $(KATA_RUNTIME_BIN_NAME)

$(eval $(golang-package))
