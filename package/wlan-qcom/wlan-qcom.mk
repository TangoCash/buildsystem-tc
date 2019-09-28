#
# wlan-qcom osmio4k | osmio4kplus
#
WLAN_QCOM_VER    = 4.5.25.32
WLAN_QCOM_DIR    = qcacld-2.0-$(WLAN_QCOM_VER)
WLAN_QCOM_SOURCE = qcacld-2.0-$(WLAN_QCOM_VER).tar.gz
WLAN_QCOM_URL    = https://www.codeaurora.org/cgit/external/wlan/qcacld-2.0/snapshot

$(ARCHIVE)/$(WLAN_QCOM_SOURCE):
	$(DOWNLOAD) $(WLAN_QCOM_URL)/$(WLAN_QCOM_SOURCE)

WLAN_QCOM_PATCH  = \
	qcacld-2.0-support.patch

$(D)/wlan-qcom: bootstrap kernel $(ARCHIVE)/$(WLAN_QCOM_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(WLAN_QCOM_DIR)
	$(UNTAR)/$(WLAN_QCOM_SOURCE)
	$(CHDIR)/$(WLAN_QCOM_DIR); \
		$(call apply_patches, $(WLAN_QCOM_PATCH)); \
		$(MAKE) $(KERNEL_MAKEVARS); \
	$(INSTALL_DATA) wlan.ko $(TARGET_MODULES_DIR)/extra/
	make depmod
	$(REMOVE)/$(WLAN_QCOM_DIR)
	$(TOUCH)
