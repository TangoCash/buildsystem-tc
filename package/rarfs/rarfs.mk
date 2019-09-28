#
# rarfs
#
RARFS_VER    = 0.1.1
RARFS_DIR    = rarfs-$(RARFS_VER)
RARFS_SOURCE = rarfs-$(RARFS_VER).tar.gz
RARFS_URL    = https://sourceforge.net/projects/rarfs/files/rarfs/$(RARFS_VER)

$(ARCHIVE)/$(RARFS_SOURCE):
	$(DOWNLOAD) $(RARFS_URL)/$(RARFS_SOURCE)

$(D)/rarfs: bootstrap fuse $(ARCHIVE)/$(RARFS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(RARFS_DIR)
	$(UNTAR)/$(RARFS_SOURCE)
	$(CHDIR)/$(RARFS_DIR); \
		$(CONFIGURE) \
			CFLAGS="$(TARGET_CFLAGS) -D_FILE_OFFSET_BITS=64" \
			--prefix=/usr \
			--disable-option-checking \
			--includedir=/usr/include/fuse \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(RARFS_DIR)
	$(TOUCH)
