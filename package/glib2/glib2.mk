#
# glib2
#
GLIB2_VER    = 2.56.3
GLIB2_DIR    = glib-$(GLIB2_VER)
GLIB2_SOURCE = glib-$(GLIB2_VER).tar.xz
GLIB2_URL    = https://ftp.gnome.org/pub/gnome/sources/glib/$(basename $(GLIB2_VER))

$(ARCHIVE)/$(GLIB2_SOURCE):
	$(DOWNLOAD) $(GLIB2_URL)/$(GLIB2_SOURCE)

GLIB2_PATCH  = \
	glib2-disable-tests.patch \
	glib2-automake.patch \
	glib2-fix-gio-linking.patch \
	gdbus-Avoid-printing-null-strings.patch

$(D)/glib2: bootstrap host-glib2 libffi util-linux zlib libiconv $(ARCHIVE)/$(GLIB2_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(GLIB2_DIR)
	$(UNTAR)/$(GLIB2_SOURCE)
	$(CHDIR)/$(GLIB2_DIR); \
		echo "glib_cv_va_copy=no" > config.cache; \
		echo "glib_cv___va_copy=yes" >> config.cache; \
		echo "glib_cv_va_val_copy=yes" >> config.cache; \
		echo "ac_cv_func_posix_getpwuid_r=yes" >> config.cache; \
		echo "ac_cv_func_posix_getgrgid_r=yes" >> config.cache; \
		echo "glib_cv_stack_grows=no" >> config.cache; \
		echo "glib_cv_uscore=no" >> config.cache; \
		echo "ac_cv_path_GLIB_GENMARSHAL=$(HOST_DIR)/bin/glib-genmarshal" >> config.cache; \
		$(call apply_patches, $(GLIB2_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			--enable-static \
			--mandir=/.remove \
			--cache-file=config.cache \
			--disable-fam \
			--disable-libmount \
			--disable-gtk-doc \
			--disable-gtk-doc-html \
			--disable-gtk-doc-pdf \
			--with-threads="posix" \
			--with-html-dir=/.remove \
			--with-pcre=internal \
			--with-libiconv=gnu \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR) localedir=/.remove/locale gnulocaledir=/.remove/locale
	$(REWRITE_LIBTOOL)/libglib-2.0.la
	$(REWRITE_LIBTOOL)/libgmodule-2.0.la
	$(REWRITE_LIBTOOL)/libgio-2.0.la
	$(REWRITE_LIBTOOL)/libgobject-2.0.la
	$(REWRITE_LIBTOOL)/libgthread-2.0.la
	rm -rf $(addprefix $(TARGET_DIR)/usr/share/,gettext gdb glib-2.0)
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,gdbus-codegen glib-compile-schemas glib-compile-resources glib-genmarshal glib-gettextize glib-mkenums gobject-query gtester gtester-report)
	$(REMOVE)/$(GLIB2_DIR)
	$(TOUCH)

#
# host-glib2
#
HOST_GLIB2_VER    = $(GLIB2_VER)
HOST_GLIB2_DIR    = glib-$(HOST_GLIB2_VER)
HOST_GLIB2_SOURCE = $(GLIB2_SOURCE)
HOST_GLIB2_PATCH  = fix-newer-gcc.patch

HOST_GLIB2_PATCH  = \
	gdbus-Avoid-printing-null-strings.patch

$(D)/host-glib2: bootstrap host-libffi $(ARCHIVE)/$(HOST_GLIB2_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HOST_GLIB2_DIR)
	$(UNTAR)/$(HOST_GLIB2_SOURCE)
	$(CHDIR)/$(HOST_GLIB2_DIR); \
		export PKG_CONFIG=/usr/bin/pkg-config; \
		export PKG_CONFIG_PATH=$(HOST_DIR)/lib/pkgconfig; \
		$(call apply_patches, $(HOST_GLIB2_PATCH)); \
		./configure $(SILENT_OPT) \
			--prefix=`pwd`/out \
			--enable-static=yes \
			--enable-shared=no \
			--disable-fam \
			--disable-libmount \
			--with-pcre=internal \
			; \
		$(MAKE) install; \
		cp -a out/bin/glib-* $(HOST_DIR)/bin
	$(REMOVE)/$(HOST_GLIB2_DIR)
	$(TOUCH)
