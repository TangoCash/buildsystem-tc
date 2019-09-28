#
# freetype
#
FREETYPE_VER    = 2.10.0
FREETYPE_DIR    = freetype-$(FREETYPE_VER)
FREETYPE_SOURCE = freetype-$(FREETYPE_VER).tar.bz2
FREETYPE_URL    = https://sourceforge.net/projects/freetype/files/freetype2/$(FREETYPE_VER)

$(ARCHIVE)/$(FREETYPE_SOURCE):
	$(DOWNLOAD) $(FREETYPE_URL)/$(FREETYPE_SOURCE)

FREETYPE_PATCH  = \
	freetype2-subpixel.patch \
	freetype2-config.patch \
	freetype2-pkgconf.patch

$(D)/freetype: bootstrap zlib libpng $(ARCHIVE)/$(FREETYPE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(FREETYPE_DIR)
	$(UNTAR)/$(FREETYPE_SOURCE)
	$(CHDIR)/$(FREETYPE_DIR); \
		$(call apply_patches, $(FREETYPE_PATCH)); \
		sed -i '/^FONT_MODULES += \(type1\|cid\|pfr\|type42\|pcf\|bdf\|winfonts\|cff\)/d' modules.cfg
	$(CHDIR)/$(FREETYPE_DIR)/builds/unix; \
		libtoolize --force --copy $(SILENT_OPT); \
		aclocal -I .; \
		autoconf
	$(CHDIR)/$(FREETYPE_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--enable-shared \
			--disable-static \
			--enable-freetype-config \
			--with-png \
			--with-zlib \
			--without-harfbuzz \
			--without-bzip2 \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	ln -sf freetype2 $(TARGET_INCLUDE_DIR)/freetype
	mv $(TARGET_DIR)/usr/bin/freetype-config $(HOST_DIR)/bin
	$(REWRITE_CONFIG) $(HOST_DIR)/bin/freetype-config
	$(REWRITE_LIBTOOL)/libfreetype.la
	$(REMOVE)/$(FREETYPE_DIR)
	$(TOUCH)
