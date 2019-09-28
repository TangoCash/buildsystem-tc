#
# libexif
#
LIBEXIF_VER    = 0.6.21
LIBEXIF_DIR    = libexif-$(LIBEXIF_VER)
LIBEXIF_SOURCE = libexif-$(LIBEXIF_VER).tar.gz
LIBEXIF_URL    = https://sourceforge.net/projects/libexif/files/libexif/$(LIBEXIF_VER)

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
