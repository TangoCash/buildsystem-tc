#
# wlan-rtl8812au
#
WLAN_RTL8812AU_VER    = 4.3.14
WLAN_RTL8812AU_DIR    = rtl8812AU-driver-$(WLAN_RTL8812AU_VER)
WLAN_RTL8812AU_SOURCE = rtl8812AU-driver-$(WLAN_RTL8812AU_VER).zip
WLAN_RTL8812AU_URL    = http://source.mynonpublic.com

$(ARCHIVE)/$(WLAN_RTL8812AU_SOURCE):
	$(DOWNLOAD) $(WLAN_RTL8812AU_URL)/$(WLAN_RTL8812AU_SOURCE)

WLAN_RTL8812AU_PATCH  = \
	rt8812au-gcc5.patch \
	rt8812au-Add-support-for-kernels-4.8.patch

$(D)/wlan-rtl8812au: bootstrap kernel $(ARCHIVE)/$(WLAN_RTL8812AU_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(WLAN_RTL8812AU_DIR)
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(WLAN_RTL8812AU_SOURCE) -d $(BUILD_DIR)
	$(CHDIR)/$(WLAN_RTL8812AU_DIR); \
		$(call apply_patches, $(WLAN_RTL8812AU_PATCH)); \
		$(MAKE) $(KERNEL_MAKEVARS); \
	$(INSTALL_DATA) 8812au.ko $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/
	make depmod
	$(REMOVE)/$(WLAN_RTL8812AU_DIR)
	$(TOUCH)
