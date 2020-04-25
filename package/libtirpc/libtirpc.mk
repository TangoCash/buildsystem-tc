#
# libtirpc
#
LIBTIRPC_VER    = 1.2.6
LIBTIRPC_DIR    = libtirpc-$(LIBTIRPC_VER)
LIBTIRPC_SOURCE = libtirpc-$(LIBTIRPC_VER).tar.bz2
LIBTIRPC_URL    = https://sourceforge.net/projects/libtirpc/files/libtirpc/$(LIBTIRPC_VER)

$(ARCHIVE)/$(LIBTIRPC_SOURCE):
	$(DOWNLOAD) $(LIBTIRPC_URL)/$(LIBTIRPC_SOURCE)

LIBTIRPC_PATCH  = \
	0001-Disable-parts-of-TIRPC-requiring-NIS-support.patch \
	0003-Automatically-generate-XDR-header-files-from-.x-sour.patch \
	0004-Add-more-XDR-files-needed-to-build-rpcbind-on-top-of.patch

$(D)/libtirpc: bootstrap $(ARCHIVE)/$(LIBTIRPC_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBTIRPC_DIR)
	$(UNTAR)/$(LIBTIRPC_SOURCE)
	$(CHDIR)/$(LIBTIRPC_DIR); \
		$(call apply_patches, $(LIBTIRPC_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) CFLAGS="$(TARGET_CFLAGS) -DGQ" \
			--prefix=/usr \
			--sysconfdir=/etc \
			--disable-gssapi \
			--mandir=/.remove \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libtirpc.la
	$(REMOVE)/$(LIBTIRPC_DIR)
	$(TOUCH)
