#
# hd60-driver
#
HD60_DRIVER_DATE   = 20190319
HD60_DRIVER_VER    = 4.4.35
HD60_DRIVER_SOURCE = hd60-drivers-$(HD60_DRIVER_VER)-$(HD60_DRIVER_DATE).zip
HD60_DRIVER_URL    = http://downloads.mutant-digital.net/hd60

$(ARCHIVE)/$(HD60_DRIVER_SOURCE):
	$(DOWNLOAD) $(HD60_DRIVER_URL)/$(HD60_DRIVER_SOURCE)

$(D)/hd60-driver: bootstrap $(ARCHIVE)/$(HD60_DRIVER_SOURCE)
	$(START_BUILD)
	mkdir -p $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(HD60_DRIVER_SOURCE) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	rm -f $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/hi_play.ko
	mkdir -p $(TARGET_DIR)/bin
	mv $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra/turnoff_power $(TARGET_DIR)/bin
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in hd60_1 hd60_2 hd60_3 hd60_4; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/_hd60.conf; \
	done
	make depmod
	$(TOUCH)
	make hd60-libs
	make hd60-libgles
	make hd60-mali-module
