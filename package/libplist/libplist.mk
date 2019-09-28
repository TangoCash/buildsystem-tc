#
# libplist
#
LIBPLIST_VER    = 2.0.0
LIBPLIST_DIR    = libplist-$(LIBPLIST_VER)
LIBPLIST_SOURCE = libplist-$(LIBPLIST_VER).tar.bz2
LIBPLIST_URL    = http://www.libimobiledevice.org/downloads

$(ARCHIVE)/$(LIBPLIST_SOURCE):
	$(DOWNLOAD) $(LIBPLIST_URL)/$(LIBPLIST_SOURCE)

$(D)/libplist: bootstrap libxml2 $(ARCHIVE)/$(LIBPLIST_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBPLIST_DIR)
	$(UNTAR)/$(LIBPLIST_SOURCE)
	$(CHDIR)/$(LIBPLIST_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--without-cython \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libplist.la
	$(REWRITE_LIBTOOL)/libplist++.la
	$(REMOVE)/$(LIBPLIST_DIR)
	$(TOUCH)
