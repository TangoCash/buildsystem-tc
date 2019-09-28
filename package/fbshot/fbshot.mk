#
# fbshot
#
FBSHOT_VER    = 0.3
FBSHOT_DIR    = fbshot-$(FBSHOT_VER)
FBSHOT_SOURCE = fbshot-$(FBSHOT_VER).tar.gz
FBSHOT_URL    = http://distro.ibiblio.org/amigolinux/download/Utils/fbshot

$(ARCHIVE)/$(FBSHOT_SOURCE):
	$(DOWNLOAD) $(FBSHOT_URL)/$(FBSHOT_SOURCE)

FBSHOT_PATCH  = \
	fbshot.patch

$(D)/fbshot: bootstrap libpng $(ARCHIVE)/$(FBSHOT_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(FBSHOT_DIR)
	$(UNTAR)/$(FBSHOT_SOURCE)
	$(CHDIR)/$(FBSHOT_DIR); \
		$(call apply_patches, $(FBSHOT_PATCH)); \
		sed -i s~'gcc'~"$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS)"~ Makefile; \
		sed -i 's/strip fbshot/$(TARGET_STRIP) fbshot/' Makefile; \
		$(MAKE) all; \
		$(INSTALL_EXEC) -D fbshot $(TARGET_DIR)/bin/fbshot
	$(REMOVE)/$(FBSHOT_DIR)
	$(TOUCH)
