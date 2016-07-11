################################################################################
#
# rtl8821au
#
################################################################################

# RTL8821AU_VERSION = driver-4.3.22-beta
RTL8821AU_VERSION = c52dd5a538b61a4d77a47c164eb8e77395116263
RTL8821AU_SITE = $(call github,diederikdehaas,rtl8812AU,$(RTL8821AU_VERSION))
RTL8821AU_LICENSE = GPLv2
RTL8821AU_LICENSE_FILES = COPYING

RTL8821AU_MODULE_MAKE_OPTS = \
	CONFIG_RTL8821AU=m \
	KVER=$(LINUX_VERSION_PROBED) \
	USER_EXTRA_CFLAGS=-DCONFIG_$(call qstrip,$(BR2_ENDIAN))_ENDIAN

$(eval $(kernel-module))
$(eval $(generic-package))
