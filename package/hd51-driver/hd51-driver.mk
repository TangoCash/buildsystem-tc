#
# hd51-driver
#
HD51_DRIVER_DATE   = 20191120
HD51_DRIVER_VER    = 4.10.12-$(HD51_DRIVER_DATE)
HD51_DRIVER_SOURCE = hd51-drivers-$(HD51_DRIVER_VER).zip
HD51_DRIVER_URL    = http://source.mynonpublic.com/gfutures

$(ARCHIVE)/$(HD51_DRIVER_SOURCE):
	$(DOWNLOAD) $(HD51_DRIVER_URL)/$(HD51_DRIVER_SOURCE)

$(D)/hd51-driver: bootstrap $(ARCHIVE)/$(HD51_DRIVER_SOURCE)
	$(START_BUILD)
	mkdir -p $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(HD51_DRIVER_SOURCE) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in hd51_1 hd51_2 hd51_3 hd51_4; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/_hd51.conf; \
	done
	make depmod
	$(TOUCH)
