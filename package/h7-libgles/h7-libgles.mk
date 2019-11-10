#
# zgemma h7-libgles
#
H7_LIBGLES_DATE   = 20191110
H7_LIBGLES_VER    = $(H7_LIBGLES_DATE)
H7_LIBGLES_SOURCE = h7-v3ddriver-$(H7_LIBGLES_VER).zip
H7_LIBGLES_URL    = http://source.mynonpublic.com/zgemma

$(ARCHIVE)/$(H7_LIBGLES_SOURCE):
	$(DOWNLOAD) $(H7_LIBGLES_URL)/$(H7_LIBGLES_SOURCE)

$(D)/h7-libgles: bootstrap $(ARCHIVE)/$(H7_LIBGLES_SOURCE)
	$(START_BUILD)
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(H7_LIBGLES_SOURCE) -d $(TARGET_DIR)/usr/lib/
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libGLESv2.so
	$(TOUCH)
