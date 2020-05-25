#
# libass
#
LIBASS_VER    = 0.14.0
LIBASS_DIR    = libass-$(LIBASS_VER)
LIBASS_SOURCE = libass-$(LIBASS_VER).tar.xz
LIBASS_URL    = https://github.com/libass/libass/releases/download/$(LIBASS_VER)

$(ARCHIVE)/$(LIBASS_SOURCE):
	$(DOWNLOAD) $(LIBASS_URL)/$(LIBASS_SOURCE)

LIBASS_PATCH  = \
	0001-libass.patch

$(D)/libass: bootstrap freetype fribidi $(ARCHIVE)/$(LIBASS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBASS_DIR)
	$(UNTAR)/$(LIBASS_SOURCE)
	$(CHDIR)/$(LIBASS_DIR); \
		$(call apply_patches, $(LIBASS_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			--disable-static \
			--disable-test \
			--disable-fontconfig \
			--disable-harfbuzz \
			--disable-require-system-font-provider \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libass.la
	$(REMOVE)/$(LIBASS_DIR)
	$(TOUCH)
