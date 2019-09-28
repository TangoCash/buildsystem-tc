#
# libsigc
#
LIBSIGC_VER    = 2.10.2
LIBSIGC_DIR    = libsigc++-$(LIBSIGC_VER)
LIBSIGC_SOURCE = libsigc++-$(LIBSIGC_VER).tar.xz
LIBSIGC_URL    = https://download.gnome.org/sources/libsigc++/$(basename $(LIBSIGC_VER))

$(ARCHIVE)/$(LIBSIGC_SOURCE):
	$(DOWNLOAD) $(LIBSIGC_URL)/$(LIBSIGC_SOURCE)

$(D)/libsigc: bootstrap $(ARCHIVE)/$(LIBSIGC_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBSIGC_DIR)
	$(UNTAR)/$(LIBSIGC_SOURCE)
	$(CHDIR)/$(LIBSIGC_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--enable-shared \
			--disable-benchmark \
			--disable-documentation \
			--disable-warnings \
			--without-boost \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR); \
		if [ -d $(TARGET_INCLUDE_DIR)/sigc++-2.0/sigc++ ] ; then \
			ln -sf ./sigc++-2.0/sigc++ $(TARGET_INCLUDE_DIR)/sigc++; \
		fi;
		mv $(TARGET_LIB_DIR)/sigc++-2.0/include/sigc++config.h $(TARGET_INCLUDE_DIR); \
		rm -fr $(TARGET_LIB_DIR)/sigc++-2.0
	$(REWRITE_LIBTOOL)/libsigc-2.0.la
	$(REMOVE)/$(LIBSIGC_DIR)
	$(TOUCH)
