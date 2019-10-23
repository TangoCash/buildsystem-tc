#
# zgemmah7-driver
#
ZGEMMAH7_DRIVER_DATE   = 20190405
ZGEMMAH7_DRIVER_VER    = 4.10.12-$(ZGEMMAH7_DRIVER_DATE)
ZGEMMAH7_DRIVER_SOURCE = h7-drivers-$(ZGEMMAH7_DRIVER_VER).zip
ZGEMMAH7_DRIVER_URL    = http://source.mynonpublic.com/zgemma

$(ARCHIVE)/$(ZGEMMAH7_DRIVER_SOURCE):
	$(DOWNLOAD) $(ZGEMMAH7_DRIVER_URL)/$(ZGEMMAH7_DRIVER_SOURCE)

$(D)/zgemmah7-driver: bootstrap $(ARCHIVE)/$(ZGEMMAH7_DRIVER_SOURCE)
	$(START_BUILD)
	mkdir -p $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(ZGEMMAH7_DRIVER_SOURCE) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in h7_1 h7_2 h7_3 h7_4; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/_h7.conf; \
	done
	make depmod
	$(TOUCH)
	make zgemmah7-libgles
