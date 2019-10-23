#
# vuzero4k-platform-util
#
VUZERO4K_PLATFORM_UTIL_DATE   = $(VUZERO4K_DRIVER_DATE)
VUZERO4K_PLATFORM_UTIL_REV    = r0
VUZERO4K_PLATFORM_UTIL_VER    = 17.1-$(VUZERO4K_PLATFORM_UTIL_DATE).$(VUZERO4K_PLATFORM_UTIL_REV)
VUZERO4K_PLATFORM_UTIL_SOURCE = platform-util-vuzero4k-$(VUZERO4K_PLATFORM_UTIL_VER).tar.gz
VUZERO4K_PLATFORM_UTIL_URL    = http://archive.vuplus.com/download/build_support/vuplus

$(ARCHIVE)/$(VUZERO4K_PLATFORM_UTIL_SOURCE):
	$(DOWNLOAD) $(VUZERO4K_PLATFORM_UTIL_URL)/$(VUZERO4K_PLATFORM_UTIL_SOURCE)

$(D)/vuzero4k-platform-util: bootstrap $(ARCHIVE)/$(VUZERO4K_PLATFORM_UTIL_SOURCE)
	$(START_BUILD)
	$(REMOVE)/platform-util-vuzero4k
	$(UNTAR)/$(VUZERO4K_PLATFORM_UTIL_SOURCE)
	$(INSTALL_EXEC) $(BUILD_DIR)/platform-util-vuzero4k/* $(TARGET_DIR)/usr/bin
	$(REMOVE)/platform-util-vuzero4k
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vuplus-platform-util $(TARGET_DIR)/etc/init.d/vuplus-platform-util
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vuplus-shutdown $(TARGET_DIR)/etc/init.d/vuplus-shutdown
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) vuplus-platform-util start 65 S . stop 90 0 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) vuplus-shutdown start 89 0 .
	$(TOUCH)
