#
# curlftpfs
#
CURLFTPFS_VER    = 0.9.2
CURLFTPFS_DIR    = curlftpfs-$(CURLFTPFS_VER)
CURLFTPFS_SOURCE = curlftpfs-$(CURLFTPFS_VER).tar.gz
CURLFTPFS_URL    = https://sourceforge.net/projects/curlftpfs/files/latest/download

$(ARCHIVE)/$(CURLFTPFS_SOURCE):
	$(DOWNLOAD) $(CURLFTPFS_URL)/$(CURLFTPFS_SOURCE)

CURLFTPFS_PATCH  = \
	curlftpfs.patch

$(D)/curlftpfs: bootstrap libcurl fuse glib2 $(ARCHIVE)/$(CURLFTPFS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(CURLFTPFS_DIR)
	$(UNTAR)/$(CURLFTPFS_SOURCE)
	$(CHDIR)/$(CURLFTPFS_DIR); \
		$(call apply_patches, $(CURLFTPFS_PATCH)); \
		export ac_cv_func_malloc_0_nonnull=yes; \
		export ac_cv_func_realloc_0_nonnull=yes; \
		$(CONFIGURE) \
			--target=$(TARGET) \
			--prefix=/usr \
			--mandir=/.remove \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(CURLFTPFS_DIR)
	$(TOUCH)
