#
# dropbear
#
DROPBEAR_VER    = 2018.76
DROPBEAR_DIR    = dropbear-$(DROPBEAR_VER)
DROPBEAR_SOURCE = dropbear-$(DROPBEAR_VER).tar.bz2
DROPBEAR_URL    = http://matt.ucc.asn.au/dropbear/releases

$(ARCHIVE)/$(DROPBEAR_SOURCE):
	$(DOWNLOAD) $(DROPBEAR_URL)/$(DROPBEAR_SOURCE)

$(D)/dropbear: bootstrap zlib $(ARCHIVE)/$(DROPBEAR_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(DROPBEAR_DIR)
	$(UNTAR)/$(DROPBEAR_SOURCE)
	$(CHDIR)/$(DROPBEAR_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--disable-pututxline \
			--disable-wtmp \
			--disable-wtmpx \
			--disable-loginfunc \
			--disable-pam \
			; \
		sed -i 's|^\(#define DROPBEAR_SMALL_CODE\).*|\1 0|' default_options.h; \
		$(MAKE) PROGRAMS="dropbear dbclient dropbearkey scp" SCPPROGRESS=1; \
		$(MAKE) PROGRAMS="dropbear dbclient dropbearkey scp" install DESTDIR=$(TARGET_DIR)
	mkdir -p $(TARGET_DIR)/etc/dropbear
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/dropbear $(TARGET_DIR)/etc/init.d/
	$(REMOVE)/$(DROPBEAR_DIR)
	$(TOUCH)
