#
# vuuno4k-libgles
#
VUUNO4K_LIBGLES_DATE   = $(VUUNO4K_DRIVER_DATE)
VUUNO4K_LIBGLES_REV    = r0
VUUNO4K_LIBGLES_VER    = 17.1-$(VUUNO4K_LIBGLES_DATE).$(VUUNO4K_LIBGLES_REV)
VUUNO4K_LIBGLES_SOURCE = libgles-vuuno4k-$(VUUNO4K_LIBGLES_VER).tar.gz
VUUNO4K_LIBGLES_URL    = http://archive.vuplus.com/download/build_support/vuplus

$(ARCHIVE)/$(VUUNO4K_LIBGLES_SOURCE):
	$(DOWNLOAD) $(VUUNO4K_LIBGLES_URL)/$(VUUNO4K_LIBGLES_SOURCE)

$(D)/vuuno4k-libgles: bootstrap $(ARCHIVE)/$(VUUNO4K_LIBGLES_SOURCE)
	$(START_BUILD)
	$(REMOVE)/libgles-vuuno4k
	$(UNTAR)/$(VUUNO4K_LIBGLES_SOURCE)
	$(INSTALL_EXEC) $(BUILD_DIR)/libgles-vuuno4k/lib/* $(TARGET_DIR)/usr/lib
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libGLESv2.so
	cp -a $(BUILD_DIR)/libgles-vuuno4k/include/* $(TARGET_DIR)/usr/include
	$(REMOVE)/libgles-vuuno4k
	$(TOUCH)
