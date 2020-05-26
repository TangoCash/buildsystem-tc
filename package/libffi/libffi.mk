#
# libffi
#
LIBFFI_VER    = 3.2.1
LIBFFI_DIR    = libffi-$(LIBFFI_VER)
LIBFFI_SOURCE = libffi-$(LIBFFI_VER).tar.gz
LIBFFI_URL    = ftp://sourceware.org/pub/libffi

$(ARCHIVE)/$(LIBFFI_SOURCE):
	$(DOWNLOAD) $(LIBFFI_URL)/$(LIBFFI_SOURCE)

LIBFFI_PATCH  = \
	0001-libffi.patch

$(D)/libffi: bootstrap $(ARCHIVE)/$(LIBFFI_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBFFI_DIR)
	$(UNTAR)/$(LIBFFI_SOURCE)
	$(CHDIR)/$(LIBFFI_DIR); \
		$(call apply_patches, $(LIBFFI_PATCH)); \
		$(CONFIGURE) \
			--target=$(TARGET) \
			--prefix=/usr \
			--mandir=/.remove \
			--infodir=/.remove \
			--disable-static \
			--enable-builddir=libffi \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libffi.la
	$(REMOVE)/$(LIBFFI_DIR)
	$(TOUCH)

#
# host-libffi
#
HOST_LIBFFI_VER    = $(LIBFFI_VER)
HOST_LIBFFI_DIR    = libffi-$(HOST_LIBFFI_VER)
HOST_LIBFFI_SOURCE = $(LIBFFI_SOURCE)

$(D)/host-libffi: $(ARCHIVE)/$(LIBFFI_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HOST_LIBFFI_DIR)
	$(UNTAR)/$(LIBFFI_SOURCE)
	$(CHDIR)/$(HOST_LIBFFI_DIR); \
		./configure $(SILENT_OPT) \
			--prefix=$(HOST_DIR) \
			--disable-static \
			; \
		$(MAKE); \
		$(MAKE) install
	$(REMOVE)/$(HOST_LIBFFI_DIR)
	$(TOUCH)
