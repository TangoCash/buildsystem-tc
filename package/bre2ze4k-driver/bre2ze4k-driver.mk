#
# bre2ze4k-driver
#
BRE2ZE4K_DRIVER_DATE   = 20191101
BRE2ZE4K_DRIVER_VER    = 4.10.12-$(BRE2ZE4K_DRIVER_DATE)
BRE2ZE4K_DRIVER_SOURCE = bre2ze4k-drivers-$(BRE2ZE4K_DRIVER_VER).zip
BRE2ZE4K_DRIVER_URL    = http://source.mynonpublic.com/gfutures

$(ARCHIVE)/$(BRE2ZE4K_DRIVER_SOURCE):
	$(DOWNLOAD) $(BRE2ZE4K_DRIVER_URL)/$(BRE2ZE4K_DRIVER_SOURCE)

$(D)/bre2ze4k-driver: bootstrap $(ARCHIVE)/$(BRE2ZE4K_DRIVER_SOURCE)
	$(START_BUILD)
	mkdir -p $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(BRE2ZE4K_DRIVER_SOURCE) -d $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in bre2ze4k_1 bre2ze4k_2 bre2ze4k_3 bre2ze4k_4; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/_bre2ze4k.conf; \
	done
	make depmod
	$(TOUCH)
	make bre2ze4k-libgles
