#
# zgemma h7-driver
#
H7_DRIVER_DATE   = 20191123
H7_DRIVER_VER    = 4.10.12-$(H7_DRIVER_DATE)
H7_DRIVER_SOURCE = h7-drivers-$(H7_DRIVER_VER).zip
H7_DRIVER_URL    = http://source.mynonpublic.com/zgemma

$(ARCHIVE)/$(H7_DRIVER_SOURCE):
	$(DOWNLOAD) $(H7_DRIVER_URL)/$(H7_DRIVER_SOURCE)

$(D)/h7-driver: bootstrap $(ARCHIVE)/$(H7_DRIVER_SOURCE)
	$(START_BUILD)
	mkdir -p $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(H7_DRIVER_SOURCE) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in h7_1 h7_2 h7_3 h7_4; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/_zgemmah7.conf; \
	done
	make depmod
	$(TOUCH)
