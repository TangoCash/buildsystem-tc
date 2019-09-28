#
# libarchive
#
LIBARCHIVE_VER    = 3.4.0
LIBARCHIVE_DIR    = libarchive-$(LIBARCHIVE_VER)
LIBARCHIVE_SOURCE = libarchive-$(LIBARCHIVE_VER).tar.gz
LIBARCHIVE_URL    = https://www.libarchive.org/downloads

$(ARCHIVE)/$(LIBARCHIVE_SOURCE):
	$(DOWNLOAD) $(LIBARCHIVE_URL)/$(LIBARCHIVE_SOURCE)

$(D)/libarchive: bootstrap $(ARCHIVE)/$(LIBARCHIVE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBARCHIVE_DIR)
	$(UNTAR)/$(LIBARCHIVE_SOURCE)
	$(CHDIR)/$(LIBARCHIVE_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--enable-static=no \
			--disable-bsdtar \
			--disable-bsdcpio \
			--without-iconv \
			--without-libiconv-prefix \
			--without-lzo2 \
			--without-nettle \
			--without-xml2 \
			--without-expat \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libarchive.la
	$(REMOVE)/$(LIBARCHIVE_DIR)
	$(TOUCH)

#
# host-libarchive
#
HOST_LIBARCHIVE_VER    = $(LIBARCHIVE_VER)
HOST_LIBARCHIVE_DIR    = $(LIBARCHIVE_DIR)
HOST_LIBARCHIVE_SOURCE = $(LIBARCHIVE_SOURCE)

$(D)/host-libarchive: bootstrap $(ARCHIVE)/$(HOST_LIBARCHIVE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HOST_LIBARCHIVE_DIR)
	$(UNTAR)/$(HOST_LIBARCHIVE_SOURCE)
	$(CHDIR)/$(HOST_LIBARCHIVE_DIR); \
		./configure $(SILENT_OPT) \
			--build=$(BUILD) \
			--host=$(BUILD) \
			--prefix= \
			--without-xml2 \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(HOST_DIR)
	$(REMOVE)/$(HOST_LIBARCHIVE_DIR)
	$(TOUCH)
