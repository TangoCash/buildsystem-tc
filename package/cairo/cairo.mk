#
# cairo
#
CAIRO_VER    = 1.16.0
CAIRO_DIR    = cairo-$(CAIRO_VER)
CAIRO_SOURCE = cairo-$(CAIRO_VER).tar.xz
CAIRO_URL    = https://www.cairographics.org/releases

$(ARCHIVE)/$(CAIRO_SOURCE):
	$(DOWNLOAD) $(CAIRO_URL)/$(CAIRO_SOURCE)

CAIRO_PATCH  = \
	0001-get_bitmap_surface.patch

$(D)/cairo: bootstrap fontconfig glib2 libpng pixman zlib $(ARCHIVE)/$(CAIRO_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(CAIRO_DIR)
	$(UNTAR)/$(CAIRO_SOURCE)
	$(CHDIR)/$(CAIRO_DIR); \
		$(call apply_patches, $(CAIRO_PATCH)); \
		$(BUILD_ENV) \
		ax_cv_c_float_words_bigendian="no" \
		./configure $(SILENT_OPT) $(CONFIGURE_OPTS) \
			--prefix=/usr \
			--with-x=no \
			--datarootdir=/.remove \
			--disable-xlib \
			--disable-xcb \
			--disable-egl \
			--disable-glesv2 \
			--disable-gl \
			--enable-tee \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	rm -rf $(TARGET_DIR)/usr/bin/cairo-sphinx
	rm -rf $(TARGET_LIB_DIR)/cairo/cairo-fdr*
	rm -rf $(TARGET_LIB_DIR)/cairo/cairo-sphinx*
	rm -rf $(TARGET_LIB_DIR)/cairo/.debug/cairo-fdr*
	rm -rf $(TARGET_LIB_DIR)/cairo/.debug/cairo-sphinx*
	$(REWRITE_LIBTOOL)/libcairo.la
	$(REWRITE_LIBTOOL)/libcairo-script-interpreter.la
	$(REWRITE_LIBTOOL)/libcairo-gobject.la
	$(REWRITE_LIBTOOL)/cairo/libcairo-trace.la
	$(REMOVE)/$(CAIRO_DIR)
	$(TOUCH)
