#
# libdvdread
#
LIBDVDREAD_VER    = 4.9.9
LIBDVDREAD_DIR    = libdvdread-$(LIBDVDREAD_VER)
LIBDVDREAD_SOURCE = libdvdread-$(LIBDVDREAD_VER).tar.xz
LIBDVDREAD_URL    = http://dvdnav.mplayerhq.hu/releases

$(ARCHIVE)/$(LIBDVDREAD_SOURCE):
	$(DOWNLOAD) $(LIBDVDREAD_URL)/$(LIBDVDREAD_SOURCE)

LIBDVDREAD_PATCH  = \
	0001-libdvdread.patch

$(D)/libdvdread: bootstrap $(ARCHIVE)/$(LIBDVDREAD_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBDVDREAD_DIR)
	$(UNTAR)/$(LIBDVDREAD_SOURCE)
	$(CHDIR)/$(LIBDVDREAD_DIR); \
		$(call apply_patches, $(LIBDVDREAD_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			--docdir=/.remove \
			--enable-static \
			--enable-shared \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libdvdread.la
	$(REMOVE)/$(LIBDVDREAD_DIR)
	$(TOUCH)
