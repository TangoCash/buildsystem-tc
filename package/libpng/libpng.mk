#
# libpng
#
LIBPNG_VER    = 1.6.37
LIBPNG_VER_X  = 16
LIBPNG_DIR    = libpng-$(LIBPNG_VER)
LIBPNG_SOURCE = libpng-$(LIBPNG_VER).tar.xz
LIBPNG_URL    = https://sourceforge.net/projects/libpng/files/libpng$(LIBPNG_VER_X)

$(ARCHIVE)/$(LIBPNG_SOURCE):
	$(DOWNLOAD) $(LIBPNG_URL)/$(LIBPNG_VER)/$(LIBPNG_SOURCE) || \
	$(DOWNLOAD) $(LIBPNG_URL)/older-releases/$(LIBPNG_VER)/$(LIBPNG_SOURCE)

LIBPNG_PATCH  = \
	0001-disable-pngfix-and-png-fix-itxt.patch

$(D)/libpng: bootstrap zlib $(ARCHIVE)/$(LIBPNG_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBPNG_DIR)
	$(UNTAR)/$(LIBPNG_SOURCE)
	$(CHDIR)/$(LIBPNG_DIR); \
		$(call apply_patches, $(LIBPNG_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			--disable-mips-msa \
			--disable-powerpc-vsx \
			--mandir=/.remove \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	mv $(TARGET_DIR)/usr/bin/libpng*-config $(HOST_DIR)/bin/
	$(REWRITE_CONFIG) $(HOST_DIR)/bin/libpng$(LIBPNG_VER_X)-config
	$(REWRITE_LIBTOOL)/libpng$(LIBPNG_VER_X).la
	$(REMOVE)/$(LIBPNG_DIR)
	$(TOUCH)
