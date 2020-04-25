#
# libnl
#
LIBNL_VER    = 3.5.0
LIBNL_DIR    = libnl-$(LIBNL_VER)
LIBNL_SOURCE = libnl-$(LIBNL_VER).tar.gz
LIBNL_URL    = https://github.com/thom311/libnl/releases/download/libnl3_5_0

$(ARCHIVE)/$(LIBNL_SOURCE):
	$(DOWNLOAD) $(LIBNL_URL)/$(LIBNL_SOURCE)

$(D)/libnl: bootstrap $(ARCHIVE)/$(LIBNL_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBNL_DIR)
	$(UNTAR)/$(LIBNL_SOURCE)
	$(CHDIR)/$(LIBNL_DIR); \
		$(CONFIGURE) \
			--target=$(TARGET) \
			--prefix=/usr \
			--sysconfdir=/etc \
			--bindir=/.remove \
			--mandir=/.remove \
			--infodir=/.remove \
			--disable-cli \
			; \
		make; \
		make install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libnl-3.la
	$(REWRITE_LIBTOOL)/libnl-genl-3.la
	$(REWRITE_LIBTOOL)/libnl-idiag-3.la
	$(REWRITE_LIBTOOL)/libnl-nf-3.la
	$(REWRITE_LIBTOOL)/libnl-route-3.la
	$(REMOVE)/$(LIBNL_DIR)
	$(TOUCH)
