#
# osmio4k-driver
#
OSMIO4K_DRIVER_DATE   = 20190917
OSMIO4K_DRIVER_VER    = 5.3.0-$(OSMIO4K_DRIVER_DATE)
OSMIO4K_DRIVER_SOURCE = osmio4k-drivers-$(OSMIO4K_DRIVER_VER).zip
OSMIO4K_DRIVER_URL    = http://source.mynonpublic.com/edision

$(ARCHIVE)/$(OSMIO4K_DRIVER_SOURCE):
	$(DOWNLOAD) $(OSMIO4K_DRIVER_URL)/$(OSMIO4K_DRIVER_SOURCE)

$(D)/osmio4k-driver: bootstrap $(ARCHIVE)/$(OSMIO4K_DRIVER_SOURCE)
	$(START_BUILD)
	mkdir -p $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(OSMIO4K_DRIVER_SOURCE) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in brcmstb-osmio4k ci si2183 avl6862 avl6261; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/_osmio4k.conf; \
	done
	make depmod
	$(TOUCH)
	make osmio4k-libgles
