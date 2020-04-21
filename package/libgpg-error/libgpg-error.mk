#
# libgpg-error
#
LIBGPG_ERROR_VER    = 1.37
LIBGPG_ERROR_DIR    = libgpg-error-$(LIBGPG_ERROR_VER)
LIBGPG_ERROR_SOURCE = libgpg-error-$(LIBGPG_ERROR_VER).tar.bz2
LIBGPG_ERROR_URL    = https://www.gnupg.org/ftp/gcrypt/libgpg-error

$(ARCHIVE)/$(LIBGPG_ERROR_SOURCE):
	$(DOWNLOAD) $(LIBGPG_ERROR_URL)/$(LIBGPG_ERROR_SOURCE)

$(D)/libgpg-error: bootstrap $(ARCHIVE)/$(LIBGPG_ERROR_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBGPG_ERROR_DIR)
	$(UNTAR)/$(LIBGPG_ERROR_SOURCE)
	$(CHDIR)/$(LIBGPG_ERROR_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--infodir=/.remove \
			--datarootdir=/.remove \
			--disable-tests \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libgpg-error.la
	$(REMOVE)/$(LIBGPG_ERROR_DIR)
	$(TOUCH)
