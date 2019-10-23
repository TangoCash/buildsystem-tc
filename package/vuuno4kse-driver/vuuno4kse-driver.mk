#
# vuuno4kse-driver
#
VUUNO4KSE_DRIVER_DATE   = 20190104
VUUNO4KSE_DRIVER_REV    = r0
VUUNO4KSE_DRIVER_VER    = 4.1.20-$(VUUNO4KSE_DRIVER_DATE).$(VUUNO4KSE_DRIVER_REV)
VUUNO4KSE_DRIVER_SOURCE = vuplus-dvb-proxy-vuuno4kse-$(VUUNO4KSE_DRIVER_VER).tar.gz
VUUNO4KSE_DRIVER_URL    = http://archive.vuplus.com/download/build_support/vuplus

$(ARCHIVE)/$(VUUNO4KSE_DRIVER_SOURCE):
	$(DOWNLOAD) $(VUUNO4KSE_DRIVER_URL)/$(VUUNO4KSE_DRIVER_SOURCE)

$(D)/vuuno4kse-driver: bootstrap $(ARCHIVE)/$(VUUNO4KSE_DRIVER_SOURCE)
	$(START_BUILD)
	mkdir -p $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	tar -xf $(ARCHIVE)/$(VUUNO4KSE_DRIVER_SOURCE) -C $(TARGET_DIR)/lib/modules/$(KERNEL_VER)/extra
	make depmod
	$(TOUCH)
	make vuuno4kse-platform-util
	make vuuno4kse-libgles
	make vuuno4kse-vmlinuz-initrd
