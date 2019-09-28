#
# links
#
LINKS_VER    = 2.20
LINKS_DIR    = links-$(LINKS_VER)
LINKS_SOURCE = links-$(LINKS_VER).tar.bz2
LINKS_URL    = http://links.twibright.com/download

$(ARCHIVE)/links-$(LINKS_VER).tar.bz2:
	$(DOWNLOAD) $(LINKS_URL)/$(LINKS_SOURCE)

LINKS_PATCH  = \
	links.patch \
	links-input.patch \
	links-ac-prog-cxx.patch \
	links-accept_https_play.patch

$(D)/links: bootstrap freetype libpng libjpeg-turbo openssl $(ARCHIVE)/$(LINKS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LINKS_DIR)
	$(UNTAR)/$(LINKS_SOURCE)
	$(CHDIR)/$(LINKS_DIR)/intl; \
		sed -i -e 's|^T_SAVE_HTML_OPTIONS,.*|T_SAVE_HTML_OPTIONS, "HTML-Optionen speichern",|' german.lng; \
		echo "english" > index.txt; \
		echo "german" >> index.txt; \
		./gen-intl
	$(CHDIR)/$(LINKS_DIR); \
		$(call apply_patches, $(LINKS_PATCH)); \
		autoreconf -vfi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--with-libjpeg \
			--without-libtiff \
			--without-svgalib \
			--without-lzma \
			--with-fb \
			--without-directfb \
			--without-pmshell \
			--without-atheos \
			--enable-graphics \
			--with-ssl=$(TARGET_DIR)/usr \
			--without-x \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	mkdir -p $(TARGET_DIR)/usr/share/tuxbox/neutrino/plugins $(TARGET_DIR)/var/tuxbox/config/links
	mv $(TARGET_DIR)/usr/bin/links $(TARGET_DIR)/usr/share/tuxbox/neutrino/plugins/links.so
	echo 'name=Links Web Browser'	 > $(TARGET_DIR)/usr/share/tuxbox/neutrino/plugins/links.cfg
	echo 'desc=Web Browser'		>> $(TARGET_DIR)/usr/share/tuxbox/neutrino/plugins/links.cfg
	echo 'type=2'			>> $(TARGET_DIR)/usr/share/tuxbox/neutrino/plugins/links.cfg
	echo 'language "German"' 	 > $(TARGET_DIR)/var/tuxbox/config/links/links.cfg
	echo 'bookmarkcount=0'		 > $(TARGET_DIR)/var/tuxbox/config/bookmarks
	touch $(TARGET_DIR)/var/tuxbox/config/links/links.his
	$(INSTALL_DATA) -D $(PKG_FILES_DIR)/bookmarks.html  $(TARGET_DIR)//var/tuxbox/config/links/bookmarks.html
	$(INSTALL_DATA) -D $(PKG_FILES_DIR)/tables.tar.gz  $(TARGET_DIR)//var/tuxbox/config/links/tables.tar.gz
	$(REMOVE)/$(LINKS_DIR)
	$(TOUCH)