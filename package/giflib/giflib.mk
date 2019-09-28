#
# giflib
#
GIFLIB_VER    = 5.1.4
GIFLIB_DIR    = giflib-$(GIFLIB_VER)
GIFLIB_SOURCE = giflib-$(GIFLIB_VER).tar.bz2
GIFLIB_URL    = https://sourceforge.net/projects/giflib/files

$(ARCHIVE)/$(GIFLIB_SOURCE):
	$(DOWNLOAD) $(GIFLIB_URL)/$(GIFLIB_SOURCE)

$(D)/giflib: bootstrap $(ARCHIVE)/$(GIFLIB_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(GIFLIB_DIR)
	$(UNTAR)/$(GIFLIB_SOURCE)
	$(CHDIR)/$(GIFLIB_DIR); \
		export ac_cv_prog_have_xmlto=no; \
		$(CONFIGURE) \
			--prefix=/usr \
			--bindir=/.remove \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libgif.la
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,gif2rgb gifbuild gifclrmp gifecho giffix gifinto giftext giftool)
	$(REMOVE)/$(GIFLIB_DIR)
	$(TOUCH)
