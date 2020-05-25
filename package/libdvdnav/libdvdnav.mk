#
# libdvdnav
#
LIBDVDNAV_VER    = 4.2.1
LIBDVDNAV_DIR    = libdvdnav-$(LIBDVDNAV_VER)
LIBDVDNAV_SOURCE = libdvdnav-$(LIBDVDNAV_VER).tar.xz
LIBDVDNAV_URL    = http://dvdnav.mplayerhq.hu/releases

$(ARCHIVE)/$(LIBDVDNAV_SOURCE):
	$(DOWNLOAD) $(LIBDVDNAV_URL)/$(LIBDVDNAV_SOURCE)

LIBDVDNAV_PATCH  = \
	0001-libdvdnav.patch

$(D)/libdvdnav: bootstrap libdvdread $(ARCHIVE)/$(LIBDVDNAV_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBDVDNAV_DIR)
	$(UNTAR)/$(LIBDVDNAV_SOURCE)
	$(CHDIR)/$(LIBDVDNAV_DIR); \
		$(call apply_patches, $(LIBDVDNAV_PATCH)); \
		$(BUILD_ENV) \
		libtoolize --copy --force --quiet --ltdl; \
		./autogen.sh \
			--build=$(BUILD) \
			--host=$(TARGET) \
			--prefix=/usr \
			--enable-static \
			--enable-shared \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libdvdnav.la
	$(REWRITE_LIBTOOL)/libdvdnavmini.la
	$(REMOVE)/$(LIBDVDNAV_DIR)
	$(TOUCH)
