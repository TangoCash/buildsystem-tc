#
# vuuno4k-platform-util
#
VUUNO4K_PLATFORM_UTIL_DATE   = 20181204
VUUNO4K_PLATFORM_UTIL_REV    = r0
VUUNO4K_PLATFORM_UTIL_VER    = 17.1-$(VUUNO4K_PLATFORM_UTIL_DATE).$(VUUNO4K_PLATFORM_UTIL_REV)
VUUNO4K_PLATFORM_UTIL_SOURCE = platform-util-vuuno4k-$(VUUNO4K_PLATFORM_UTIL_VER).tar.gz
VUUNO4K_PLATFORM_UTIL_URL    = http://archive.vuplus.com/download/build_support/vuplus

$(ARCHIVE)/$(VUUNO4K_PLATFORM_UTIL_SOURCE):
	$(DOWNLOAD) $(VUUNO4K_PLATFORM_UTIL_URL)/$(VUUNO4K_PLATFORM_UTIL_SOURCE)

$(D)/vuuno4k-platform-util: bootstrap $(ARCHIVE)/$(VUUNO4K_PLATFORM_UTIL_SOURCE)
	$(START_BUILD)
	$(REMOVE)/platform-util-vuuno4k
	$(UNTAR)/$(VUUNO4K_PLATFORM_UTIL_SOURCE)
	$(INSTALL_EXEC) $(BUILD_DIR)/platform-util-vuuno4k/* $(TARGET_DIR)/usr/bin
	$(REMOVE)/platform-util-vuuno4k
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vuplus-platform-util $(TARGET_DIR)/etc/init.d/vuplus-platform-util
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vuplus-shutdown $(TARGET_DIR)/etc/init.d/vuplus-shutdown
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) vuplus-platform-util start 65 S . stop 90 0 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) vuplus-shutdown start 89 0 .
	$(TOUCH)
