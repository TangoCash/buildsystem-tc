#
# gptfdisk
#
GPTFDISK_VER    = 1.0.5
GPTFDISK_DIR    = gptfdisk-$(GPTFDISK_VER)
GPTFDISK_SOURCE = gptfdisk-$(GPTFDISK_VER).tar.gz
GPTFDISK_URL    = https://sourceforge.net/projects/gptfdisk/files/gptfdisk/$(GPTFDISK_VER)

$(ARCHIVE)/$(GPTFDISK_SOURCE):
	$(DOWNLOAD) $(GPTFDISK_URL)/$(GPTFDISK_SOURCE)

$(D)/gptfdisk: bootstrap e2fsprogs ncurses popt $(ARCHIVE)/$(GPTFDISK_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(GPTFDISK_DIR)
	$(UNTAR)/$(GPTFDISK_SOURCE)
	$(CHDIR)/$(GPTFDISK_DIR); \
		$(BUILD_ENV) \
		$(MAKE) sgdisk; \
		$(INSTALL_EXEC) sgdisk $(TARGET_DIR)/usr/sbin/sgdisk
	$(REMOVE)/$(GPTFDISK_DIR)
	$(TOUCH)
