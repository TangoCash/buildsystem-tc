#
# wlan-rtl8822bu
#
WLAN_RTL8822BU_VER    = 1.0.0.9-20180511a
WLAN_RTL8822BU_DIR    = rtl8822bu
WLAN_RTL8822BU_SOURCE = rtl8822bu-driver-$(WLAN_RTL8822BU_VER).zip
WLAN_RTL8822BU_URL    = http://source.mynonpublic.com

$(ARCHIVE)/$(WLAN_RTL8822BU_SOURCE):
	$(DOWNLOAD) $(WLAN_RTL8812AU_URL)/$(WLAN_RTL8822BU_SOURCE)

WLAN_RTL8822BU_PATCH  = \
	add-linux-4.19-support.patch \
	add-linux-4.20-support.patch \
	add-linux-5.0-support.patch \
	add-linux-5.1-support.patch \
	add-linux-5.2-support.patch

$(D)/wlan-rtl8822bu: bootstrap kernel $(ARCHIVE)/$(WLAN_RTL8822BU_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(WLAN_RTL8822BU_DIR)
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(WLAN_RTL8822BU_SOURCE) -d $(BUILD_DIR)
	$(CHDIR)/$(WLAN_RTL8822BU_DIR); \
		$(call apply_patches, $(WLAN_RTL8822BU_PATCH)); \
		$(MAKE) $(KERNEL_MAKEVARS); \
	$(INSTALL_DATA) 88x2bu.ko $(TARGET_MODULES_DIR)/kernel/drivers/net/wireless/
	make depmod
	$(REMOVE)/$(WLAN_RTL8822BU_DIR)
	$(TOUCH)
