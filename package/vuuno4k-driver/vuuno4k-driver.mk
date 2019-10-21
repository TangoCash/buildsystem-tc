#
# vuuno4k-driver
#
VUUNO4K_DRIVER_DATE   = 20190104
VUUNO4K_DRIVER_REV    = r0
VUUNO4K_DRIVER_VER    = 3.14.28-$(VUUNO4K_DRIVER_DATE).$(VUUNO4K_DRIVER_REV)
VUUNO4K_DRIVER_SOURCE = vuplus-dvb-proxy-vuuno4k-$(VUUNO4K_DRIVER_VER).tar.gz
VUUNO4K_DRIVER_URL    = http://archive.vuplus.com/download/build_support/vuplus

$(ARCHIVE)/$(VUUNO4K_DRIVER_SOURCE):
	$(DOWNLOAD) $(VUUNO4K_DRIVER_URL)/$(VUUNO4K_DRIVER_SOURCE)

$(D)/vuuno4k-driver: bootstrap $(ARCHIVE)/$(VUUNO4K_DRIVER_SOURCE)
	$(START_BUILD)
	mkdir -p $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	tar -xf $(ARCHIVE)/$(VUUNO4K_DRIVER_SOURCE) -C $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	make depmod
	$(TOUCH)
	make vuuno4k-platform-util
	make vuuno4k-libgles
	make vuuno4k-vmlinuz-initrd
