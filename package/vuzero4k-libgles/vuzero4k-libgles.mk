#
# vuzero4k-libgles
#
VUZERO4K_LIBGLES_DATE   = $(VUZERO4K_DRIVER_DATE)
VUZERO4K_LIBGLES_REV    = r0
VUZERO4K_LIBGLES_VER    = 17.1-$(VUZERO4K_LIBGLES_DATE).$(VUZERO4K_LIBGLES_REV)
VUZERO4K_LIBGLES_SOURCE = libgles-vuzero4k-$(VUZERO4K_LIBGLES_VER).tar.gz
VUZERO4K_LIBGLES_URL    = http://archive.vuplus.com/download/build_support/vuplus

$(ARCHIVE)/$(VUZERO4K_LIBGLES_SOURCE):
	$(DOWNLOAD) $(VUZERO4K_LIBGLES_URL)/$(VUZERO4K_LIBGLES_SOURCE)

$(D)/vuzero4k-libgles: bootstrap $(ARCHIVE)/$(VUZERO4K_LIBGLES_SOURCE)
	$(START_BUILD)
	$(REMOVE)/libgles-vuzero4k
	$(UNTAR)/$(VUZERO4K_LIBGLES_SOURCE)
	$(INSTALL_EXEC) $(BUILD_DIR)/libgles-vuzero4k/lib/* $(TARGET_DIR)/usr/lib
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libGLESv2.so
	cp -a $(BUILD_DIR)/libgles-vuzero4k/include/* $(TARGET_DIR)/usr/include
	$(REMOVE)/libgles-vuzero4k
	$(TOUCH)
