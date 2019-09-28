#
# ntfs-3g
#
NTFS_3G_VER    = 2017.3.23
NTFS_3G_DIR    = ntfs-3g_ntfsprogs-$(NTFS_3G_VER)
NTFS_3G_SOURCE = ntfs-3g_ntfsprogs-$(NTFS_3G_VER).tgz
NTFS_3G_URL    = https://tuxera.com/opensource

$(ARCHIVE)/$(NTFS_3G_SOURCE):
	$(DOWNLOAD) $(NTFS_3G_URL)/$(NTFS_3G_SOURCE)

NTFS_3G_PATCH  = \
	001-fuseint-fix-path-mounted-on-musl.patch \
	002-ntfs-3g-sysmacros.patch

$(D)/ntfs-3g: bootstrap fuse $(ARCHIVE)/$(NTFS_3G_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(NTFS_3G_DIR)
	$(UNTAR)/$(NTFS_3G_SOURCE)
	$(CHDIR)/$(NTFS_3G_DIR); \
		$(call apply_patches, $(NTFS_3G_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			--exec-prefix=/usr \
			--bindir=/usr/bin \
			--mandir=/.remove \
			--docdir=/.remove \
			--disable-ntfsprogs \
			--disable-ldconfig \
			--disable-library \
			--with-fuse=external \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,lowntfs-3g ntfs-3g.probe)
	rm -f $(addprefix $(TARGET_DIR)/sbin/,mount.lowntfs-3g)
	ln -sf mount.ntfs-3g $(TARGET_DIR)/sbin/mount.ntfs
	$(REMOVE)/$(NTFS_3G_DIR)
	$(TOUCH)
