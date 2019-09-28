#
# fontconfig
#
FONTCONFIG_VER    = 2.11.93
FONTCONFIG_DIR    = fontconfig-$(FONTCONFIG_VER)
FONTCONFIG_SOURCE = fontconfig-$(FONTCONFIG_VER).tar.bz2
FONTCONFIG_URL    = https://www.freedesktop.org/software/fontconfig/release

$(ARCHIVE)/$(FONTCONFIG_SOURCE):
	$(DOWNLOAD) $(FONTCONFIG_URL)/$(FONTCONFIG_SOURCE)

FONTCONFIG_PATCH  = \
	fontconfig-glibc.patch

$(D)/fontconfig: bootstrap freetype expat $(ARCHIVE)/$(FONTCONFIG_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(FONTCONFIG_DIR)
	$(UNTAR)/$(FONTCONFIG_SOURCE)
	$(CHDIR)/$(FONTCONFIG_DIR); \
		$(call apply_patches, $(FONTCONFIG_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			--with-freetype-config=$(HOST_DIR)/bin/freetype-config \
			--with-expat-includes=$(TARGET_INCLUDE_DIR) \
			--with-expat-lib=$(TARGET_LIB_DIR) \
			--sysconfdir=/etc \
			--disable-docs \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libfontconfig.la
	$(REMOVE)/$(FONTCONFIG_DIR)
	$(TOUCH)
