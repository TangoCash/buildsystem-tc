#
# vusolo4k-platform-util
#
VUSOLO4K_PLATFORM_UTIL_DATE   = 20190424
VUSOLO4K_PLATFORM_UTIL_REV    = r0
VUSOLO4K_PLATFORM_UTIL_VER    = 17.1-$(VUSOLO4K_PLATFORM_UTIL_DATE).$(VUSOLO4K_PLATFORM_UTIL_REV)
VUSOLO4K_PLATFORM_UTIL_SOURCE = platform-util-vusolo4k-$(VUSOLO4K_PLATFORM_UTIL_VER).tar.gz
VUSOLO4K_PLATFORM_UTIL_URL    = http://archive.vuplus.com/download/build_support/vuplus

$(ARCHIVE)/$(VUSOLO4K_PLATFORM_UTIL_SOURCE):
	$(DOWNLOAD) $(VUSOLO4K_PLATFORM_UTIL_URL)/$(VUSOLO4K_PLATFORM_UTIL_SOURCE)

$(D)/vusolo4k-platform-util: bootstrap $(ARCHIVE)/$(VUSOLO4K_PLATFORM_UTIL_SOURCE)
	$(START_BUILD)
	$(REMOVE)/platform-util-vusolo4k
	$(UNTAR)/$(VUSOLO4K_PLATFORM_UTIL_SOURCE)
	$(INSTALL_EXEC) $(BUILD_DIR)/platform-util-vusolo4k/* $(TARGET_DIR)/usr/bin
	$(REMOVE)/platform-util-vusolo4k
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vuplus-platform-util $(TARGET_DIR)/etc/init.d/vuplus-platform-util
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vuplus-shutdown $(TARGET_DIR)/etc/init.d/vuplus-shutdown
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) vuplus-platform-util start 65 S . stop 90 0 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) vuplus-shutdown start 89 0 .
	$(TOUCH)
