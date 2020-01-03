#
# streamripper
#
STREAMRIPPER_VER    = git
STREAMRIPPER_DIR    = ni-streamripper.$(STREAMRIPPER_VER)
STREAMRIPPER_SOURCE = $(STREAMRIPPER_DIR)
STREAMRIPPER_URL    = https://github.com/neutrino-images/$(STREAMRIPPER_SOURCE)

$(D)/streamripper: bootstrap libvorbisidec libmad glib2
	$(START_BUILD)
	$(REMOVE)/$(STREAMRIPPER_DIR)
	$(GET-GIT-SOURCE) $(STREAMRIPPER_URL) $(ARCHIVE)/$(STREAMRIPPER_SOURCE)
	$(CPDIR)/$(STREAMRIPPER_DIR)
	$(CHDIR)/$(STREAMRIPPER_DIR); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix= \
			--includedir=$(TARGET_INCLUDE_DIR) \
			--datarootdir=/.remove \
			--with-included-argv=yes \
			--with-included-libmad=no \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
		$(INSTALL_EXEC) $(PKG_FILES_DIR)/streamripper.sh $(TARGET_DIR)/bin/
	$(REMOVE)/$(STREAMRIPPER_DIR)
	$(TOUCH)
