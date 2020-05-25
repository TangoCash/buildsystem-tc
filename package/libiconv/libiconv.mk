#
# libiconv
#
LIBICONV_VER    = 1.13.1
LIBICONV_DIR    = libiconv-$(LIBICONV_VER)
LIBICONV_SOURCE = libiconv-$(LIBICONV_VER).tar.gz
LIBICONV_URL    = https://ftp.gnu.org/gnu/libiconv

$(ARCHIVE)/$(LIBICONV_SOURCE):
	$(DOWNLOAD) $(LIBICONV_URL)/$(LIBICONV_SOURCE)

LIBICONV_PATCH  = \
	0001-disable_transliterations.patch \
	0002-strip_charsets.patch

$(D)/libiconv: bootstrap $(ARCHIVE)/$(LIBICONV_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBICONV_DIR)
	$(UNTAR)/$(LIBICONV_SOURCE)
	$(CHDIR)/$(LIBICONV_DIR); \
		$(call apply_patches, $(LIBICONV_PATCH)); \
		$(CONFIGURE) CPPFLAGS="$(TARGET_CPPFLAGS) -fPIC" \
			--target=$(TARGET) \
			--prefix=/usr \
			--datarootdir=/.remove \
			--enable-static \
			--disable-shared \
			--enable-relocatable \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libcharset.la
	$(REWRITE_LIBTOOL)/libiconv.la
	rm -f $(addprefix $(TARGET_LIB_DIR)/,preloadable_libiconv.so)
	$(REMOVE)/$(LIBICONV_DIR)
	$(TOUCH)
