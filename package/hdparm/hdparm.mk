#
# hdparm
#
HDPARM_VER    = 9.58
HDPARM_DIR    = hdparm-$(HDPARM_VER)
HDPARM_SOURCE = hdparm-$(HDPARM_VER).tar.gz
HDPARM_URL    = https://sourceforge.net/projects/hdparm/files/hdparm

$(ARCHIVE)/$(HDPARM_SOURCE):
	$(DOWNLOAD) $(HDPARM_URL)/$(HDPARM_SOURCE)

$(D)/hdparm: bootstrap $(ARCHIVE)/$(HDPARM_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HDPARM_DIR)
	$(UNTAR)/$(HDPARM_SOURCE)
	$(CHDIR)/$(HDPARM_DIR); \
		$(BUILD_ENV) \
		$(MAKE) CROSS=$(TARGET_CROSS) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR) mandir=/.remove
	$(REMOVE)/$(HDPARM_DIR)
	$(TOUCH)
