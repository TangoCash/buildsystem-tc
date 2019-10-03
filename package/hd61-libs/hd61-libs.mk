#
# hd61-libs
#
HD61_LIBS_DATE   = 20190120
HD61_LIBS_VER    = $(HD61_LIBS_DATE)
HD61_LIBS_SOURCE = hd61-libs-$(HD61_LIBS_VER).zip
HD61_LIBS_URL    = http://downloads.mutant-digital.net/hd61

$(ARCHIVE)/$(HD61_LIBS_SOURCE):
	$(DOWNLOAD) $(HD61_LIBS_URL)/$(HD61_LIBS_SOURCE)

$(D)/hd61-libs: bootstrap $(ARCHIVE)/$(HD61_LIBS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/hiplay
	mkdir -p $(TARGET_DIR)/usr/lib/hisilicon
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(HD61_LIBS_SOURCE) -d $(BUILD_DIR)/hiplay
	mkdir -p $(TARGET_DIR)/usr/lib/hisilicon
	$(INSTALL_EXEC) $(BUILD_DIR)/hiplay/hisilicon/* $(TARGET_DIR)/usr/lib/hisilicon
	$(INSTALL_EXEC) $(BUILD_DIR)/hiplay/ffmpeg/* $(TARGET_DIR)/usr/lib/hisilicon
	ln -sf /lib/ld-linux-armhf.so.3 $(TARGET_DIR)/usr/lib/hisilicon/ld-linux.so
	$(REMOVE)/hiplay
	$(TOUCH)
