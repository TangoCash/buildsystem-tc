#
# osmio4kplus-driver
#
OSMIO4KPLUS_DRIVER_DATE   = 20190917
OSMIO4KPLUS_DRIVER_VER    = 5.3.0-$(OSMIO4KPLUS_DRIVER_DATE)
OSMIO4KPLUS_DRIVER_SOURCE = osmio4kplus-drivers-$(OSMIO4KPLUS_DRIVER_VER).zip
OSMIO4KPLUS_DRIVER_URL    = http://source.mynonpublic.com/edision

$(ARCHIVE)/$(OSMIO4KPLUS_DRIVER_SOURCE):
	$(DOWNLOAD) $(OSMIO4KPLUS_DRIVER_URL)/$(OSMIO4KPLUS_DRIVER_SOURCE)

$(D)/osmio4kplus-driver: bootstrap $(ARCHIVE)/$(OSMIO4KPLUS_DRIVER_SOURCE)
	$(START_BUILD)
	mkdir -p $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(OSMIO4KPLUS_DRIVER_SOURCE) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in brcmstb-osmio4kplus ci si2183 avl6862 avl6261; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/_osmio4kplus.conf; \
	done
	make depmod
	$(TOUCH)
	make osmio4kplus-libgles
	make wlan-qcom
