################################################################################
#
# docker-engine
#
################################################################################

DOCKER_ENGINE_VERSION = v18.06.1-ce
DOCKER_ENGINE_SITE = $(call github,docker,engine,$(DOCKER_ENGINE_VERSION))

DOCKER_ENGINE_LICENSE = Apache-2.0
DOCKER_ENGINE_LICENSE_FILES = LICENSE

DOCKER_ENGINE_DEPENDENCIES = host-go host-pkgconf
DOCKER_ENGINE_SRC_SUBDIR = github.com/docker/docker

DOCKER_ENGINE_LDFLAGS = \
	-X main.GitCommit=$(DOCKER_ENGINE_VERSION) \
	-X main.Version=$(DOCKER_ENGINE_VERSION)

DOCKER_ENGINE_TAGS = cgo exclude_graphdriver_zfs autogen
DOCKER_ENGINE_BUILD_TARGETS = cmd/dockerd

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
DOCKER_ENGINE_TAGS += seccomp
DOCKER_ENGINE_DEPENDENCIES += libseccomp
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
DOCKER_ENGINE_TAGS += journald
DOCKER_ENGINE_DEPENDENCIES += systemd
DOCKER_ENGINE_TAGS += systemd journald
endif

ifeq ($(BR2_PACKAGE_DOCKER_ENGINE_EXPERIMENTAL),y)
DOCKER_ENGINE_TAGS += experimental
endif

ifeq ($(BR2_PACKAGE_DOCKER_ENGINE_DRIVER_BTRFS),y)
DOCKER_ENGINE_DEPENDENCIES += btrfs-progs
else
DOCKER_ENGINE_TAGS += exclude_graphdriver_btrfs
endif

ifeq ($(BR2_PACKAGE_DOCKER_ENGINE_DRIVER_DEVICEMAPPER),y)
DOCKER_ENGINE_DEPENDENCIES += lvm2
else
DOCKER_ENGINE_TAGS += exclude_graphdriver_devicemapper
endif

ifeq ($(BR2_PACKAGE_DOCKER_ENGINE_DRIVER_VFS),y)
DOCKER_ENGINE_DEPENDENCIES += gvfs
else
DOCKER_ENGINE_TAGS += exclude_graphdriver_vfs
endif

DOCKER_ENGINE_INSTALL_BINS = $(notdir $(DOCKER_ENGINE_BUILD_TARGETS))

ifeq ($(BR2_PACKAGE_DOCKER_ENGINE_INIT_DUMB_INIT),y)
DOCKER_ENGINE_INIT_BIN = dumb-init
else
DOCKER_ENGINE_INIT_BIN = tini
endif

define DOCKER_ENGINE_RUN_AUTOGEN
	cd $(@D) && \
		BUILDTIME="$$(date)" \
		IAMSTATIC="true" \
		VERSION="$(patsubst v%,%,$(DOCKER_ENGINE_VERSION))" \
		PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" $(TARGET_MAKE_ENV) \
		bash ./hack/make/.go-autogen
endef

DOCKER_ENGINE_POST_CONFIGURE_HOOKS += DOCKER_ENGINE_RUN_AUTOGEN

define DOCKER_ENGINE_LINK_INIT
	ln -fs $(DOCKER_ENGINE_INIT_BIN) \
		$(TARGET_DIR)/usr/bin/docker-init
endef

DOCKER_ENGINE_POST_INSTALL_TARGET_HOOKS += DOCKER_ENGINE_LINK_INIT

define DOCKER_ENGINE_LINK_CONTAINERD
	ln -fs containerd \
		$(TARGET_DIR)/usr/bin/docker-containerd
endef

DOCKER_ENGINE_POST_INSTALL_TARGET_HOOKS += DOCKER_ENGINE_LINK_CONTAINERD

define DOCKER_ENGINE_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(@D)/contrib/init/systemd/docker.service \
		$(TARGET_DIR)/usr/lib/systemd/system/docker.service
	$(INSTALL) -D -m 0644 $(@D)/contrib/init/systemd/docker.socket \
		$(TARGET_DIR)/usr/lib/systemd/system/docker.socket
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/
	ln -fs ../../../../usr/lib/systemd/system/docker.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/docker.service
endef

define DOCKER_ENGINE_USERS
	- - docker -1 * - - - Docker Application Container Framework
endef

$(eval $(golang-package))
