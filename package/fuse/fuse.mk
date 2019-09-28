#
# fuse
#
FUSE_VER    = 2.9.8
FUSE_DIR    = fuse-$(FUSE_VER)
FUSE_SOURCE = fuse-$(FUSE_VER).tar.gz
FUSE_URL    = https://github.com/libfuse/libfuse/releases/download/fuse-$(FUSE_VER)

$(ARCHIVE)/$(FUSE_SOURCE):
	$(DOWNLOAD) $(FUSE_URL)/$(FUSE_SOURCE)

FUSE_PATCH = \
	0001-fix-aarch64-build.patch

$(D)/fuse: bootstrap $(ARCHIVE)/$(FUSE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(FUSE_DIR)
	$(UNTAR)/$(FUSE_SOURCE)
	$(CHDIR)/$(FUSE_DIR); \
		$(call apply_patches, $(FUSE_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			--exec-prefix=/usr \
			--mandir=/.remove \
			--disable-static \
			--disable-example \
			--disable-mtab \
			--with-gnu-ld \
			--enable-util \
			--enable-lib \
			--enable-silent-rules \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	-rm -rf $(TARGET_DIR)/etc/udev
	$(REWRITE_LIBTOOL)/libfuse.la
	$(REWRITE_LIBTOOL)/libulockmgr.la
	$(REMOVE)/$(FUSE_DIR)
	$(TOUCH)
