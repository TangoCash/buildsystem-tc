#
# hddtemp
#
HDDTEMP_VER    = 0.3-beta15
HDDTEMP_DIR    = hddtemp-$(HDDTEMP_VER)
HDDTEMP_SOURCE = hddtemp-$(HDDTEMP_VER).tar.bz2
HDDTEMP_URL    = http://savannah.c3sl.ufpr.br/hddtemp

$(ARCHIVE)/$(HDDTEMP_SOURCE):
	$(DOWNLOAD) $(HDDTEMP_URL)/$(HDDTEMP_SOURCE)

$(D)/hddtemp: bootstrap libiconv $(ARCHIVE)/$(HDDTEMP_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HDDTEMP_DIR)
	$(UNTAR)/$(HDDTEMP_SOURCE)
	$(CHDIR)/$(HDDTEMP_DIR); \
		$(CONFIGURE) LIBS="-liconv" \
			--prefix= \
			--mandir=/.remove \
			--datadir=/.remove \
			--with-db_path=/usr/share/misc/hddtemp.db \
			--disable-dependency-tracking \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(INSTALL_DATA) -D $(PKG_FILES_DIR)/hddtemp.db $(TARGET_DIR)/usr/share/misc/hddtemp.db
	ln -sf /usr/share/misc/hddtemp.db $(TARGET_DIR)/etc/hddtemp.db
	$(REMOVE)/$(HDDTEMP_DIR)
	$(TOUCH)
