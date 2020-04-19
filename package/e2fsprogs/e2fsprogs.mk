#
# e2fsprogs
#
E2FSPROGS_VER    = 1.45.5
E2FSPROGS_DIR    = e2fsprogs-$(E2FSPROGS_VER)
E2FSPROGS_SOURCE = e2fsprogs-$(E2FSPROGS_VER).tar.gz
E2FSPROGS_URL    = https://sourceforge.net/projects/e2fsprogs/files/e2fsprogs/v$(E2FSPROGS_VER)

$(ARCHIVE)/$(E2FSPROGS_SOURCE):
	$(DOWNLOAD) $(E2FSPROGS_URL)/$(E2FSPROGS_SOURCE)

E2FSPROGS_PATCH  = \
	000-e2fsprogs.patch \
	001-exit_0_on_corrected_errors.patch \
	002-dont-build-e4defrag.patch \
	003-overridable-pc-exec-prefix.patch \
	004-Revert-mke2fs-enable-the-metadata_csum-and-64bit-fea.patch \
	005-misc-create_inode.c-set-dir-s-mode-correctly.patch \
	006-mkdir_p.patch \
	007-no-crond.patch

$(D)/e2fsprogs: bootstrap util-linux $(ARCHIVE)/$(E2FSPROGS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(E2FSPROGS_DIR)
	$(UNTAR)/$(E2FSPROGS_SOURCE)
	$(CHDIR)/$(E2FSPROGS_DIR); \
		$(call apply_patches, $(E2FSPROGS_PATCH)); \
		PATH=$(BUILD_DIR)/e2fsprogs-$(E2FSPROGS_VER):$(PATH) \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) LIBS="-luuid -lblkid" \
			ac_cv_path_LDCONFIG=true \
			--prefix=/usr \
			--libdir=/usr/lib \
			--datarootdir=/.remove \
			--mandir=/.remove \
			--infodir=/.remove \
			--disable-backtrace \
			--disable-blkid-debug \
			--disable-bmap-stats \
			--disable-debugfs \
			--disable-defrag \
			--disable-e2initrd-helper \
			--disable-fuse2fs \
			--disable-imager \
			--disable-jbd-debug \
			--disable-mmp \
			--disable-nls \
			--disable-rpath \
			--disable-testio-debug \
			--disable-tdb \
			--enable-elf-shlibs \
			--enable-fsck \
			--disable-libblkid \
			--disable-libuuid \
			--disable-uuidd \
			--enable-verbose-makecmds \
			--enable-symlink-install \
			--without-libintl-prefix \
			--without-libiconv-prefix \
			--with-root-prefix="" \
			--with-crond-dir=no \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	rm -f $(addprefix $(TARGET_DIR)/sbin/,badblocks dumpe2fs e2mmpstatus e2undo logsave)
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/,filefrag e2freefrag mk_cmds mklost+found uuidd e4crypt)
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,chattr compile_et mk_cmds lsattr uuidgen)
	$(REMOVE)/$(E2FSPROGS_DIR)
	$(TOUCH)

#
# host-e2fsprogs
#
HOST_E2FSPROGS_VER    = $(E2FSPROGS_VER)
HOST_E2FSPROGS_DIR    = e2fsprogs-$(HOST_E2FSPROGS_VER)
HOST_E2FSPROGS_SOURCE = $(E2FSPROGS_SOURCE)

$(D)/host-e2fsprogs: directories $(ARCHIVE)/$(HOST_E2FSPROGS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HOST_E2FSPROGS_DIR)
	$(UNTAR)/$(HOST_E2FSPROGS_SOURCE)
	$(CHDIR)/$(HOST_E2FSPROGS_DIR); \
		export PKG_CONFIG=/usr/bin/pkg-config; \
		export PKG_CONFIG_PATH=$(HOST_DIR)/lib/pkgconfig; \
		./configure $(SILENT_OPT); \
		$(MAKE)
	$(INSTALL_EXEC) -D $(BUILD_DIR)/$(HOST_E2FSPROGS_DIR)/resize/resize2fs $(HOST_DIR)/bin/
	$(INSTALL_EXEC) -D $(BUILD_DIR)/$(HOST_E2FSPROGS_DIR)/misc/mke2fs $(HOST_DIR)/bin/
	ln -sf mke2fs $(HOST_DIR)/bin/mkfs.ext2
	ln -sf mke2fs $(HOST_DIR)/bin/mkfs.ext3
	ln -sf mke2fs $(HOST_DIR)/bin/mkfs.ext4
	ln -sf mke2fs $(HOST_DIR)/bin/mkfs.ext4dev
	$(INSTALL_EXEC) -D $(BUILD_DIR)/$(HOST_E2FSPROGS_DIR)/e2fsck/e2fsck $(HOST_DIR)/bin/
	ln -sf e2fsck $(HOST_DIR)/bin/fsck.ext2
	ln -sf e2fsck $(HOST_DIR)/bin/fsck.ext3
	ln -sf e2fsck $(HOST_DIR)/bin/fsck.ext4
	ln -sf e2fsck $(HOST_DIR)/bin/fsck.ext4dev
	$(REMOVE)/$(HOST_E2FSPROGS_DIR)
	$(TOUCH)
