#
# smartmontools
#
SMARTMONTOOLS_VER    = 7.0
SMARTMONTOOLS_DIR    = smartmontools-$(SMARTMONTOOLS_VER)
SMARTMONTOOLS_SOURCE = smartmontools-$(SMARTMONTOOLS_VER).tar.gz
SMARTMONTOOLS_URL    = https://sourceforge.net/projects/smartmontools/files/smartmontools/$(SMARTMONTOOLS_VER)

$(ARCHIVE)/$(SMARTMONTOOLS_SOURCE):
	$(DOWNLOAD) $(SMARTMONTOOLS_URL)/$(SMARTMONTOOLS_SOURCE)

$(D)/smartmontools: bootstrap $(ARCHIVE)/$(SMARTMONTOOLS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(SMARTMONTOOLS_DIR)
	$(UNTAR)/$(SMARTMONTOOLS_SOURCE)
	$(CHDIR)/$(SMARTMONTOOLS_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			; \
		$(MAKE); \
		$(INSTALL_EXEC) smartctl $(TARGET_DIR)/usr/sbin/smartctl
	$(REMOVE)/$(SMARTMONTOOLS_DIR)
	$(TOUCH)
