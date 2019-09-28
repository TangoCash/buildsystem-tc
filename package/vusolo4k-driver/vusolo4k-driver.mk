#
# vusolo4k-driver
#
VUSOLO4K_DRIVER_DATE   = 20190424
VUSOLO4K_DRIVER_REV    = r0
VUSOLO4K_DRIVER_VER    = 3.14.28-$(VUSOLO4K_DRIVER_DATE).$(VUSOLO4K_DRIVER_REV)
VUSOLO4K_DRIVER_SOURCE = vuplus-dvb-proxy-vusolo4k-$(VUSOLO4K_DRIVER_VER).tar.gz
VUSOLO4K_DRIVER_URL    = http://archive.vuplus.com/download/build_support/vuplus

$(ARCHIVE)/$(VUSOLO4K_DRIVER_SOURCE):
	$(DOWNLOAD) $(VUSOLO4K_DRIVER_URL)/$(VUSOLO4K_DRIVER_SOURCE)

$(D)/vusolo4k-driver: bootstrap $(ARCHIVE)/$(VUSOLO4K_DRIVER_SOURCE)
	$(START_BUILD)
	mkdir -p $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	tar -xf $(ARCHIVE)/$(VUSOLO4K_DRIVER_SOURCE) -C $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	make depmod
	$(TOUCH)
	make vusolo4k-platform-util
	make vusolo4k-libgles
	make vusolo4k-vmlinuz-initrd
