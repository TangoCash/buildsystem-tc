#
# lzo
#
LZO_VER    = 2.10
LZO_DIR    = lzo-$(LZO_VER)
LZO_SOURCE = lzo-$(LZO_VER).tar.gz
LZO_URL    = https://www.oberhumer.com/opensource/lzo/download

$(ARCHIVE)/$(LZO_SOURCE):
	$(DOWNLOAD) $(LZO_URL)/$(LZO_SOURCE)

$(D)/lzo: bootstrap $(ARCHIVE)/$(LZO_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LZO_DIR)
	$(UNTAR)/$(LZO_SOURCE)
	$(CHDIR)/$(LZO_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--docdir=/.remove \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/liblzo2.la
	$(REMOVE)/$(LZO_DIR)
	$(TOUCH)
