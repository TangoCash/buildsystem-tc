#
# vuultimo4k-libgles
#
VUULTIMO4K_LIBGLES_DATE   = 20181204
VUULTIMO4K_LIBGLES_REV    = r0
VUULTIMO4K_LIBGLES_VER    = 17.1-$(VUULTIMO4K_LIBGLES_DATE).$(VUULTIMO4K_LIBGLES_REV)
VUULTIMO4K_LIBGLES_SOURCE = libgles-vuultimo4k-$(VUULTIMO4K_LIBGLES_VER).tar.gz
VUULTIMO4K_LIBGLES_URL    = http://archive.vuplus.com/download/build_support/vuplus

$(ARCHIVE)/$(VUULTIMO4K_LIBGLES_SOURCE):
	$(DOWNLOAD) $(VUULTIMO4K_LIBGLES_URL)/$(VUULTIMO4K_LIBGLES_SOURCE)

$(D)/vuultimo4k-libgles: bootstrap $(ARCHIVE)/$(VUULTIMO4K_LIBGLES_SOURCE)
	$(START_BUILD)
	$(REMOVE)/libgles-vuultimo4k
	$(UNTAR)/$(VUULTIMO4K_LIBGLES_SOURCE)
	$(INSTALL_EXEC) $(BUILD_DIR)/libgles-vuultimo4k/lib/* $(TARGET_DIR)/usr/lib
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libGLESv2.so
	cp -a $(BUILD_DIR)/libgles-vuultimo4k/include/* $(TARGET_DIR)/usr/include
	$(REMOVE)/libgles-vuultimo4k
	$(TOUCH)
