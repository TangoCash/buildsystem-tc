#
# hd60-libs
#
HD60_LIBS_DATE   = 20190120
HD60_LIBS_VER    = $(HD60_LIBS_DATE)
HD60_LIBS_SOURCE = hd60-libs-$(HD60_LIBS_VER).zip
HD60_LIBS_URL    = http://downloads.mutant-digital.net/hd60

$(ARCHIVE)/$(HD60_LIBS_SOURCE):
	$(DOWNLOAD) $(HD60_LIBS_URL)/$(HD60_LIBS_SOURCE)

$(D)/hd60-libs: bootstrap $(ARCHIVE)/$(HD60_LIBS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/hiplay
	mkdir -p $(TARGET_DIR)/usr/lib/hisilicon
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(HD60_LIBS_SOURCE) -d $(BUILD_DIR)/hiplay
	mkdir -p $(TARGET_DIR)/usr/lib/hisilicon
	$(INSTALL_EXEC) $(BUILD_DIR)/hiplay/hisilicon/* $(TARGET_DIR)/usr/lib/hisilicon
	$(INSTALL_EXEC) $(BUILD_DIR)/hiplay/ffmpeg/* $(TARGET_DIR)/usr/lib/hisilicon
	ln -sf /lib/ld-linux-armhf.so.3 $(TARGET_DIR)/usr/lib/hisilicon/ld-linux.so
	$(REMOVE)/hiplay
	$(TOUCH)
