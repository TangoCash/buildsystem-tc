#
# libgd
#
LIBGD_VER    = 2.2.5
LIBGD_DIR    = libgd-$(LIBGD_VER)
LIBGD_SOURCE = libgd-$(LIBGD_VER).tar.xz
LIBGD_URL    = https://github.com/libgd/libgd/releases/download/gd-$(LIBGD_VER)

$(ARCHIVE)/$(LIBGD_SOURCE):
	$(DOWNLOAD) $(LIBGD_URL)/$(LIBGD_SOURCE)

$(D)/libgd: bootstrap libpng libjpeg-turbo freetype $(ARCHIVE)/$(LIBGD_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBGD_DIR)
	$(UNTAR)/$(LIBGD_SOURCE)
	$(CHDIR)/$(LIBGD_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--bindir=/.remove \
			--without-fontconfig \
			--without-xpm \
			--without-x \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libgd.la
	$(REMOVE)/$(LIBGD_DIR)
	$(TOUCH)
