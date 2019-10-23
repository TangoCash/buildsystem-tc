#
# vuuno4kse-platform-util
#
VUUNO4KSE_PLATFORM_UTIL_DATE   = $(VUUNO4KSE_DRIVER_DATE)
VUUNO4KSE_PLATFORM_UTIL_REV    = r0
VUUNO4KSE_PLATFORM_UTIL_VER    = 17.1-$(VUUNO4KSE_PLATFORM_UTIL_DATE).$(VUUNO4KSE_PLATFORM_UTIL_REV)
VUUNO4KSE_PLATFORM_UTIL_SOURCE = platform-util-vuuno4kse-$(VUUNO4KSE_PLATFORM_UTIL_VER).tar.gz
VUUNO4KSE_PLATFORM_UTIL_URL    = http://archive.vuplus.com/download/build_support/vuplus

$(ARCHIVE)/$(VUUNO4KSE_PLATFORM_UTIL_SOURCE):
	$(DOWNLOAD) $(VUUNO4K_PLATFORM_UTIL_URL)/$(VUUNO4KSE_PLATFORM_UTIL_SOURCE)

$(D)/vuuno4kse-platform-util: bootstrap $(ARCHIVE)/$(VUUNO4KSE_PLATFORM_UTIL_SOURCE)
	$(START_BUILD)
	$(REMOVE)/platform-util-vuuno4kse
	$(UNTAR)/$(VUUNO4KSE_PLATFORM_UTIL_SOURCE)
	$(INSTALL_EXEC) $(BUILD_DIR)/platform-util-vuuno4kse/* $(TARGET_DIR)/usr/bin
	$(REMOVE)/platform-util-vuuno4kse
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vuplus-platform-util $(TARGET_DIR)/etc/init.d/vuplus-platform-util
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/vuplus-shutdown $(TARGET_DIR)/etc/init.d/vuplus-shutdown
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) vuplus-platform-util start 65 S . stop 90 0 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) vuplus-shutdown start 89 0 .
	$(TOUCH)
