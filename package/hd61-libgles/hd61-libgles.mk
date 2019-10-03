#
# hd61-libgles
#
HD61_LIBGLES_DATE   = 20181201
HD61_LIBGLES_VER    = $(HD61_LIBGLES_DATE)
HD61_LIBGLES_SOURCE = hd61-mali-$(HD61_LIBGLES_VER).zip
HD61_LIBGLES_URL    = http://downloads.mutant-digital.net/hd61

$(ARCHIVE)/$(HD61_LIBGLES_SOURCE):
	$(DOWNLOAD) $(HD61_LIBGLES_URL)/$(HD61_LIBGLES_SOURCE)

$(D)/hd61-libgles: bootstrap $(ARCHIVE)/$(HD61_LIBGLES_SOURCE)
	$(START_BUILD)
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(HD61_LIBGLES_SOURCE) -d $(TARGET_DIR)/usr/lib
	(cd $(TARGET_DIR)/usr/lib && ln -sf libMali.so libmali.so)
	(cd $(TARGET_DIR)/usr/lib && ln -sf libMali.so libEGL.so.1.4 && ln -sf libEGL.so.1.4 libEGL.so.1 && ln -sf libEGL.so.1 libEGL.so)
	(cd $(TARGET_DIR)/usr/lib && ln -sf libMali.so libGLESv1_CM.so.1.1 && ln -sf libGLESv1_CM.so.1.1 libGLESv1_CM.so.1 && ln -sf libGLESv1_CM.so.1 libGLESv1_CM.so)
	(cd $(TARGET_DIR)/usr/lib && ln -sf libMali.so libGLESv2.so.2.0 && ln -sf libGLESv2.so.2.0 libGLESv2.so.2  && ln -sf libGLESv2.so.2 libGLESv2.so)
	(cd $(TARGET_DIR)/usr/lib && ln -sf libMali.so libgbm.so)
	cp $(PKG_FILES_DIR)/* $(TARGET_DIR)/usr/lib/pkgconfig
	$(TOUCH)
