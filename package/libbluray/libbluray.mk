#
# libbluray
#
LIBBLURAY_VER    = 0.9.3
LIBBLURAY_DIR    = libbluray-$(LIBBLURAY_VER)
LIBBLURAY_SOURCE = libbluray-$(LIBBLURAY_VER).tar.bz2
LIBBLURAY_URL    = ftp.videolan.org/pub/videolan/libbluray/$(LIBBLURAY_VER)

$(ARCHIVE)/$(LIBBLURAY_SOURCE):
	$(DOWNLOAD) $(LIBBLURAY_URL)/$(LIBBLURAY_SOURCE)

LIBBLURAY_PATCH  = \
	libbluray.patch

$(D)/libbluray: bootstrap $(ARCHIVE)/$(LIBBLURAY_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBBLURAY_DIR)
	$(UNTAR)/$(LIBBLURAY_SOURCE)
	$(CHDIR)/$(LIBBLURAY_DIR); \
		$(call apply_patches, $(LIBBLURAY_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			--enable-shared \
			--disable-static \
			--disable-extra-warnings \
			--disable-doxygen-doc \
			--disable-doxygen-dot \
			--disable-doxygen-html \
			--disable-doxygen-ps \
			--disable-doxygen-pdf \
			--disable-examples \
			--disable-bdjava \
			--without-libxml2 \
			--without-fontconfig \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libbluray.la
	$(REMOVE)/$(LIBBLURAY_DIR)
	$(TOUCH)
