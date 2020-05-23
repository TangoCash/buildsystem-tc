#
# libexif
#
LIBEXIF_VER    = 0.6.22
LIBEXIF_DIR    = libexif-$(LIBEXIF_VER)
LIBEXIF_SOURCE = libexif-$(LIBEXIF_VER).tar.xz
LIBEXIF_URL    = https://github.com/libexif/libexif/releases/download/libexif-$(subst .,_,$(LIBEXIF_VER))-release

$(ARCHIVE)/$(LIBEXIF_SOURCE):
	$(DOWNLOAD) $(LIBEXIF_URL)/$(LIBEXIF_SOURCE)

$(D)/libexif: bootstrap $(ARCHIVE)/$(LIBEXIF_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBEXIF_DIR)
	$(UNTAR)/$(LIBEXIF_SOURCE)
	$(CHDIR)/$(LIBEXIF_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			; \
		$(MAKE); \
		$(MAKE) install prefix=/usr DESTDIR=$(TARGET_DIR) datadir=/.remove docdir=/.remove
	$(REWRITE_LIBTOOL)/libexif.la
	$(REMOVE)/$(LIBEXIF_DIR)
	$(TOUCH)
