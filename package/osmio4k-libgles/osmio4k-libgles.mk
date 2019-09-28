#
# osmio4k-libgles
#
OSMIO4K_LIBGLES_VER    = 1.0
OSMIO4K_LIBGLES_DIR    = libv3d-osmio4k-$(OSMIO4K_LIBGLES_VER)
OSMIO4K_LIBGLES_SOURCE = libv3d-osmio4k-$(OSMIO4K_LIBGLES_VER).tar.xz
OSMIO4K_LIBGLES_URL    = http://source.mynonpublic.com/edision

$(ARCHIVE)/$(OSMIO4K_LIBGLES_SOURCE):
	$(DOWNLOAD) $(OSMIO4K_LIBGLES_URL)/$(OSMIO4K_LIBGLES_SOURCE)

$(D)/osmio4k-libgles: bootstrap $(ARCHIVE)/$(OSMIO4K_LIBGLES_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(OSMIO4K_LIBGLES_DIR)
	$(UNTAR)/$(OSMIO4K_LIBGLES_SOURCE)
	cp -a $(PKG_BUILD_DIR)/* $(TARGET_DIR)/usr/
	ln -sf libv3ddriver.so.1.0 $(TARGET_DIR)/usr/lib/libEGL.so
	ln -sf libv3ddriver.so.1.0 $(TARGET_DIR)/usr/lib/libGLESv2.so
	$(REMOVE)/$(OSMIO4K_LIBGLES_DIR)
	$(TOUCH)
