#
# libogg
#
LIBOGG_VER    = 1.3.4
LIBOGG_DIR    = libogg-$(LIBOGG_VER)
LIBOGG_SOURCE = libogg-$(LIBOGG_VER).tar.gz
LIBOGG_URL    = https://ftp.osuosl.org/pub/xiph/releases/ogg

$(ARCHIVE)/$(LIBOGG_SOURCE):
	$(DOWNLOAD) $(LIBOGG_URL)/$(LIBOGG_SOURCE)

$(D)/libogg: bootstrap $(ARCHIVE)/$(LIBOGG_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBOGG_DIR)
	$(UNTAR)/$(LIBOGG_SOURCE)
	$(CHDIR)/$(LIBOGG_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--docdir=/.remove \
			--enable-shared \
			--disable-static \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libogg.la
	$(REMOVE)/$(LIBOGG_DIR)
	$(TOUCH)
