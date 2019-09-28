#
# vuduo4k-libgles
#
VUDUO4K_LIBGLES_DATE   = 20190212
VUDUO4K_LIBGLES_REV    = r0
VUDUO4K_LIBGLES_VER    = 18.1-$(VUDUO4K_LIBGLES_DATE).$(VUDUO4K_LIBGLES_REV)
VUDUO4K_LIBGLES_SOURCE = libgles-vuduo4k-$(VUDUO4K_LIBGLES_VER).tar.gz
VUDUO4K_LIBGLES_URL    = http://archive.vuplus.com/download/build_support/vuplus

$(ARCHIVE)/$(VUDUO4K_LIBGLES_SOURCE):
	$(DOWNLOAD) $(VUDUO4K_LIBGLES_URL)/$(VUDUO4K_LIBGLES_SOURCE)

$(D)/vuduo4k-libgles: bootstrap $(ARCHIVE)/$(VUDUO4K_LIBGLES_SOURCE)
	$(START_BUILD)
	$(REMOVE)/libgles-vuduo4k
	$(UNTAR)/$(VUDUO4K_LIBGLES_SOURCE)
	$(INSTALL_EXEC) $(BUILD_DIR)/libgles-vuduo4k/lib/* $(TARGET_DIR)/usr/lib
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libGLESv2.so
	cp -a $(BUILD_DIR)/libgles-vuduo4k/include/* $(TARGET_DIR)/usr/include
	$(REMOVE)/libgles-vuduo4k
	$(TOUCH)
