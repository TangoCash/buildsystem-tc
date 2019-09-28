#
# wireless-tools
#
WIRELESS_TOOLS_VER    = 29
WIRELESS_TOOLS_DIR    = wireless_tools.$(WIRELESS_TOOLS_VER)
WIRELESS_TOOLS_SOURCE = wireless_tools.$(WIRELESS_TOOLS_VER).tar.gz
WIRELESS_TOOLS_URL    = https://hewlettpackard.github.io/wireless-tools

$(ARCHIVE)/$(WIRELESS_TOOLS_SOURCE):
	$(DOWNLOAD) $(WIRELESS_TOOLS_URL)/$(WIRELESS_TOOLS_SOURCE)

WIRELESS_TOOLS_PATCH  = \
	wireless-tools.patch

$(D)/wireless-tools: bootstrap $(ARCHIVE)/$(WIRELESS_TOOLS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(WIRELESS_TOOLS_DIR)
	$(UNTAR)/$(WIRELESS_TOOLS_SOURCE)
	$(CHDIR)/$(WIRELESS_TOOLS_DIR); \
		$(call apply_patches, $(WIRELESS_TOOLS_PATCH)); \
		$(MAKE) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS) -I."; \
		$(MAKE) install PREFIX=$(TARGET_DIR)/usr INSTALL_MAN=$(TARGET_DIR)/.remove
	$(REMOVE)/$(WIRELESS_TOOLS_DIR)
	$(TOUCH)
