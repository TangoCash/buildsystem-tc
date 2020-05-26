#
# ncurses
#
NCURSES_VER    = 6.0
NCURSES_DIR    = ncurses-$(NCURSES_VER)
NCURSES_SOURCE = ncurses-$(NCURSES_VER).tar.gz
NCURSES_URL    = https://ftp.gnu.org/pub/gnu/ncurses

$(ARCHIVE)/$(NCURSES_SOURCE):
	$(DOWNLOAD) $(NCURSES_URL)/$(NCURSES_SOURCE)

NCURSES_PATCH  = \
	0001-gcc-5.x-MKlib_gen.patch

$(D)/ncurses: bootstrap $(ARCHIVE)/$(NCURSES_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(NCURSES_DIR)
	$(UNTAR)/$(NCURSES_SOURCE)
	$(CHDIR)/$(NCURSES_DIR); \
		$(call apply_patches, $(NCURSES_PATCH)); \
		$(CONFIGURE) \
			--target=$(TARGET) \
			--prefix=/usr \
			--enable-pc-files \
			--with-pkg-config \
			--with-pkg-config-libdir=/usr/lib/pkgconfig \
			--with-shared \
			--with-fallbacks='linux vt100 xterm' \
			--without-ada \
			--without-cxx \
			--without-cxx-binding \
			--without-debug \
			--without-gpm \
			--without-manpages \
			--without-profile \
			--without-progs \
			--without-tests \
			--disable-big-core \
			--disable-rpath \
			--disable-rpath-hack \
			--enable-const \
			--enable-overwrite \
			; \
		$(MAKE) libs \
			HOSTCC=gcc \
			HOSTCCFLAGS="$(CFLAGS) -DHAVE_CONFIG_H -I../ncurses -DNDEBUG -D_GNU_SOURCE -I../include" \
			HOSTLDFLAGS="$(LDFLAGS)"; \
		$(MAKE) install.libs DESTDIR=$(TARGET_DIR)
	mv $(TARGET_DIR)/usr/bin/ncurses6-config $(HOST_DIR)/bin
	$(REWRITE_CONFIG) $(HOST_DIR)/bin/ncurses6-config
	$(REMOVE)/$(NCURSES_DIR)
	$(TOUCH)
