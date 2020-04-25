#
# vuduo4k-platform-util
#
VUDUO4K_PLATFORM_UTIL_DATE   = 20190212
VUDUO4K_PLATFORM_UTIL_REV    = r0
VUDUO4K_PLATFORM_UTIL_VER    = 18.1-$(VUDUO4K_PLATFORM_UTIL_DATE).$(VUDUO4K_PLATFORM_UTIL_REV)
VUDUO4K_PLATFORM_UTIL_SOURCE = platform-util-vuduo4k-$(VUDUO4K_PLATFORM_UTIL_VER).tar.gz
VUDUO4K_PLATFORM_UTIL_URL    = http://archive.vuplus.com/download/build_support/vuplus

$(ARCHIVE)/$(VUDUO4K_PLATFORM_UTIL_SOURCE):
	$(DOWNLOAD) $(VUDUO4K_PLATFORM_UTIL_URL)/$(VUDUO4K_PLATFORM_UTIL_SOURCE)

$(D)/vuduo4k-platform-util: bootstrap $(ARCHIVE)/$(VUDUO4K_PLATFORM_UTIL_SOURCE)
	$(START_BUILD)
	$(REMOVE)/platform-util-vuduo4k
	$(UNTAR)/$(VUDUO4K_PLATFORM_UTIL_SOURCE)
	$(INSTALL_EXEC) $(BUILD_DIR)/platform-util-vuduo4k/* $(TARGET_DIR)/usr/bin
	$(REMOVE)/platform-util-vuduo4k
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vuplus-platform-util $(TARGET_DIR)/etc/init.d/vuplus-platform-util
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vuplus-shutdown $(TARGET_DIR)/etc/init.d/vuplus-shutdown
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/bp3flash.sh $(TARGET_DIR)/usr/bin/bp3flash.sh
	$(UPDATE-RC.D) vuplus-platform-util start 65 S . stop 90 0 .
	$(UPDATE-RC.D) vuplus-shutdown start 89 0 .
	$(TOUCH)
