#
# libdvdcss
#
LIBDVDCSS_VER    = 1.2.13
LIBDVDCSS_DIR    = libdvdcss-$(LIBDVDCSS_VER)
LIBDVDCSS_SOURCE = libdvdcss-$(LIBDVDCSS_VER).tar.bz2
LIBDVDCSS_URL    = https://download.videolan.org/pub/libdvdcss/$(LIBDVDCSS_VER)

$(ARCHIVE)/$(LIBDVDCSS_SOURCE):
	$(DOWNLOAD) $(LIBDVDCSS_URL)/$(LIBDVDCSS_SOURCE)

$(D)/libdvdcss: bootstrap $(ARCHIVE)/$(LIBDVDCSS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBDVDCSS_DIR)
	$(UNTAR)/$(LIBDVDCSS_SOURCE)
	$(CHDIR)/$(LIBDVDCSS_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--disable-doc \
			--docdir=/.remove \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libdvdcss.la
	$(REMOVE)/$(LIBDVDCSS_DIR)
	$(TOUCH)
