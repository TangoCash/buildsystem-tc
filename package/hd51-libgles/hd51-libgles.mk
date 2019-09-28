#
# hd51-libgles
#
HD51_LIBGLES_DATE   = 20170322
HD51_LIBGLES_VER    = $(HD51_LIBGLES_DATE)
HD51_LIBGLES_SOURCE = hd51-v3ddriver-$(HD51_LIBGLES_VER).zip
HD51_LIBGLES_URL    = http://downloads.mutant-digital.net/v3ddriver

$(ARCHIVE)/$(HD51_LIBGLES_SOURCE):
	$(DOWNLOAD) $(HD51_LIBGLES_URL)/$(HD51_LIBGLES_SOURCE)

$(D)/hd51-libgles: bootstrap $(ARCHIVE)/$(HD51_LIBGLES_SOURCE)
	$(START_BUILD)
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(HD51_LIBGLES_SOURCE) -d $(TARGET_DIR)/usr/lib/
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libGLESv2.so
	$(TOUCH)
