################################################################################
#
# rtl8188fu
#
################################################################################

RTL8188FU_VERSION = fab4f5db4580d9a920f99c64dceaa5711589559d
RTL8188FU_SITE = $(call github,ulli-kroll,rtl8188fu,$(RTL8188FU_VERSION))
RTL8188FU_LICENSE = GPL-2.0
RTL8188FU_LICENSE_FILES = LICENSE

RTL8188FU_MODULE_MAKE_OPTS = \
	CONFIG_RTL8188FU=m \
	KVER=$(LINUX_VERSION_PROBED) \
	USER_EXTRA_CFLAGS="-DCONFIG_$(call qstrip,$(BR2_ENDIAN))_ENDIAN \
		-Wno-error"

$(eval $(kernel-module))
$(eval $(generic-package))
