#
# bash
#
BASH_VER    = 5.0
BASH_DIR    = bash-$(BASH_VER)
BASH_SOURCE = bash-$(BASH_VER).tar.gz
BASH_URL    = http://ftp.gnu.org/gnu/bash

$(ARCHIVE)/$(BASH_SOURCE):
	$(DOWNLOAD) $(BASH_URL)/$(BASH_SOURCE)

$(D)/bash: bootstrap ncurses $(ARCHIVE)/$(BASH_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(BASH_DIR)
	$(UNTAR)/$(BASH_SOURCE)
	$(CHDIR)/$(BASH_DIR); \
		$(call apply_patches, $(PKG_PATCHES_DIR), 0); \
		$(CONFIGURE); \
		$(MAKE); \
		$(INSTALL_EXEC) bash $(TARGET_DIR)/bin
	$(REMOVE)/$(BASH_DIR)
	$(TOUCH)
