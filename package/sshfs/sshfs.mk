#
# sshfs
#
SSHFS_VER    = 2.9
SSHFS_DIR    = sshfs-$(SSHFS_VER)
SSHFS_SOURCE = sshfs-$(SSHFS_VER).tar.gz
SSHFS_URL    = https://github.com/libfuse/sshfs/releases/download/sshfs-$(SSHFS_VER)

$(ARCHIVE)/$(SSHFS_SOURCE):
	$(DOWNLOAD) $(SSHFS_URL)/$(SSHFS_SOURCE)

$(D)/sshfs: bootstrap glib2 fuse $(ARCHIVE)/$(SSHFS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(SSHFS_DIR)
	$(UNTAR)/$(SSHFS_SOURCE)
	$(CHDIR)/$(SSHFS_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(SSHFS_DIR)
	$(TOUCH)
