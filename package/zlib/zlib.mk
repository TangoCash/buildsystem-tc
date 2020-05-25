#
# zlib
#
ZLIB_VER    = 1.2.11
ZLIB_DIR    = zlib-$(ZLIB_VER)
ZLIB_SOURCE = zlib-$(ZLIB_VER).tar.xz
ZLIB_URL    = https://sourceforge.net/projects/libpng/files/zlib/$(ZLIB_VER)

$(ARCHIVE)/$(ZLIB_SOURCE):
	$(DOWNLOAD) $(ZLIB_URL)/$(ZLIB_SOURCE)

ZLIB_PATCH  = \
	0001-zlib.patch

$(D)/zlib: bootstrap $(ARCHIVE)/$(ZLIB_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(ZLIB_DIR)
	$(UNTAR)/$(ZLIB_SOURCE)
	$(CHDIR)/$(ZLIB_DIR); \
		$(call apply_patches, $(ZLIB_PATCH)); \
		$(BUILD_ENV) \
		mandir=/.remove \
		./configure $(SILENT_OPT) \
			--prefix=/usr \
			--shared \
			--uname=Linux \
			; \
		$(MAKE); \
		ln -sf /bin/true ldconfig; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(ZLIB_DIR)
	$(TOUCH)
