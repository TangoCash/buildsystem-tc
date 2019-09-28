#
# vuultimo4k-driver
#
VUULTIMO4K_DRIVER_DATE   = 20181204
VUULTIMO4K_DRIVER_REV    = r0
VUULTIMO4K_DRIVER_VER    = 3.14.28-$(VUULTIMO4K_DRIVER_DATE).$(VUULTIMO4K_DRIVER_REV)
VUULTIMO4K_DRIVER_SOURCE = vuplus-dvb-proxy-vuultimo4k-$(VUULTIMO4K_DRIVER_VER).tar.gz
VUULTIMO4K_DRIVER_URL    = http://archive.vuplus.com/download/build_support/vuplus

$(ARCHIVE)/$(VUULTIMO4K_DRIVER_SOURCE):
	$(DOWNLOAD) $(VUULTIMO4K_DRIVER_URL)/$(VUULTIMO4K_DRIVER_SOURCE)

$(D)/vuultimo4k-driver: bootstrap $(ARCHIVE)/$(VUULTIMO4K_DRIVER_SOURCE)
	$(START_BUILD)
	mkdir -p $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	tar -xf $(ARCHIVE)/$(VUULTIMO4K_DRIVER_SOURCE) -C $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	make depmod
	$(TOUCH)
	make vuultimo4k-platform-util
	make vuultimo4k-libgles
	make vuultimo4k-vmlinuz-initrd
