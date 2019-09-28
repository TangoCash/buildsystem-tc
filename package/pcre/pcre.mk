#
# pcre
#
PCRE_VER    = 8.39
PCRE_DIR    = pcre-$(PCRE_VER)
PCRE_SOURCE = pcre-$(PCRE_VER).tar.bz2
PCRE_URL    = https://sourceforge.net/projects/pcre/files/pcre/$(PCRE_VER)

$(ARCHIVE)/$(PCRE_SOURCE):
	$(DOWNLOAD) $(PCRE_URL)/$(PCRE_SOURCE)

$(D)/pcre: bootstrap $(ARCHIVE)/$(PCRE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(PCRE_DIR)
	$(UNTAR)/$(PCRE_SOURCE)
	$(CHDIR)/$(PCRE_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--docdir=/.remove \
			--enable-utf8 \
			--enable-unicode-properties \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	mv $(TARGET_DIR)/usr/bin/pcre-config $(HOST_DIR)/bin/pcre-config
	$(REWRITE_CONFIG) $(HOST_DIR)/bin/pcre-config
	$(REWRITE_LIBTOOL)/libpcre.la
	$(REWRITE_LIBTOOL)/libpcrecpp.la
	$(REWRITE_LIBTOOL)/libpcreposix.la
	$(REMOVE)/$(PCRE_DIR)
	$(TOUCH)
