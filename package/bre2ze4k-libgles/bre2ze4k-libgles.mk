#
# bre2ze4k-libgles
#
BRE2ZE4K_LIBGLES_DATE   = 20191101
BRE2ZE4K_LIBGLES_VER    = $(BRE2ZE4K_LIBGLES_DATE)
BRE2ZE4K_LIBGLES_SOURCE = bre2ze4k-v3ddriver-$(BRE2ZE4K_LIBGLES_VER).zip
BRE2ZE4K_LIBGLES_URL    = http://downloads.mutant-digital.net/v3ddriver

$(ARCHIVE)/$(BRE2ZE4K_LIBGLES_SOURCE):
	$(DOWNLOAD) $(BRE2ZE4K_LIBGLES_URL)/$(BRE2ZE4K_LIBGLES_SOURCE)

$(D)/bre2ze4k-libgles: bootstrap $(ARCHIVE)/$(BRE2ZE4K_LIBGLES_SOURCE)
	$(START_BUILD)
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(BRE2ZE4K_LIBGLES_SOURCE) -d $(TARGET_DIR)/usr/lib/
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libEGL.so
	ln -sf libv3ddriver.so $(TARGET_DIR)/usr/lib/libGLESv2.so
	$(TOUCH)
