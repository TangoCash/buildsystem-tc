#
# zgemmah7-libgles
#
ZGEMMAH7_LIBGLES_DATE   = 20170320
ZGEMMAH7_LIBGLES_VER    = $(ZGEMMAH7_LIBGLES_DATE)
ZGEMMAH7_LIBGLES_SOURCE = h7-v3ddriver-$(ZGEMMAH7_LIBGLES_VER).zip
ZGEMMAH7_LIBGLES_URL    = http://source.mynonpublic.com/zgemma

$(ARCHIVE)/$(ZGEMMAH7_LIBGLES_SOURCE):
	$(DOWNLOAD) $(ZGEMMAH7_LIBGLES_URL)/$(ZGEMMAH7_LIBGLES_SOURCE)

$(D)/zgemmah7-libgles: bootstrap $(ARCHIVE)/$(ZGEMMAH7_LIBGLES_SOURCE)
	$(START_BUILD)
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(ZGEMMAH7_LIBGLES_SOURCE) -d $(TARGET_DIR)/usr/lib/
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libGLESv2.so
	$(TOUCH)
