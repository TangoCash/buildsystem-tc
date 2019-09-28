#
# libtirpc
#
LIBTIRPC_VER    = 1.1.4
LIBTIRPC_DIR    = libtirpc-$(LIBTIRPC_VER)
LIBTIRPC_SOURCE = libtirpc-$(LIBTIRPC_VER).tar.bz2
LIBTIRPC_URL    = https://sourceforge.net/projects/libtirpc/files/libtirpc/$(LIBTIRPC_VER)

$(ARCHIVE)/$(LIBTIRPC_SOURCE):
	$(DOWNLOAD) $(LIBTIRPC_URL)/$(LIBTIRPC_SOURCE)

LIBTIRPC_PATCH  = \
	0001-Disable-parts-of-TIRPC-requiring-NIS-support.patch \
	0002-uClibc-without-RPC-support-and-musl-does-not-install-rpcent.h.patch \
	0003-Automatically-generate-XDR-header-files-from-.x-sour.patch \
	0004-Add-more-XDR-files-needed-to-build-rpcbind-on-top-of.patch \
	0005-Disable-DES-authentification-support.patch \
	0006-rpc-types.h-fix-musl-build.patch \
	010-b-functions.patch

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
