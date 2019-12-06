#
# nfs-utils
#
NFS_UTILS_VER    = 2.3.3
NFS_UTILS_DIR    = nfs-utils-$(NFS_UTILS_VER)
NFS_UTILS_SOURCE = nfs-utils-$(NFS_UTILS_VER).tar.bz2
NFS_UTILS_URL    = https://sourceforge.net/projects/nfs/files/nfs-utils/$(NFS_UTILS_VER)

$(ARCHIVE)/$(NFS_UTILS_SOURCE):
	$(DOWNLOAD) $(NFS_UTILS_URL)/$(NFS_UTILS_SOURCE)

NFS_UTILS_PATCH  = \
	debianize-start-statd.patch \
	bugfix-adjust-statd-service-name.patch \
	musl-limits.patch \
	cacheio-use-intmax_t-for-formatted-IO.patch \
	Do-not-pass-null-pointer-to-freeaddrinfo.patch \
	clang-format-string.patch \
	Makefile.am-update-the-path-of-libnfs.a.patch \
	Makefile.am-fix-undefined-function-for-libnsm.a.patch \
	Don-t-build-tools-with-CC_FOR_BUILD.patch \
	configure.ac-Do-not-fatalize-Wmissing-prototypes.patch \
	disabled-ip6-support.patch

NFS-UTILS_CONF = $(if $(filter $(BOXMODEL), vuduo), --disable-ipv6, --enable-ipv6)

$(D)/nfs-utils: bootstrap rpcbind e2fsprogs $(ARCHIVE)/$(NFS_UTILS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(NFS_UTILS_DIR)
	$(UNTAR)/$(NFS_UTILS_SOURCE)
	$(CHDIR)/$(NFS_UTILS_DIR); \
		$(call apply_patches, $(NFS_UTILS_PATCH)); \
		export knfsd_cv_bsd_signals=no; \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--sysconfdir=/etc \
			--mandir=/.remove \
			--disable-gss \
			--disable-nfsv4 \
			--disable-nfsv41 \
			$(NFS-UTILS_CONF) \
			--enable-mount \
			--enable-libmount-mount \
			--without-tcp-wrappers \
			--without-systemd \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(INSTALL_DATA) $(PKG_FILES_DIR)/exports $(TARGET_DIR)/etc/exports
	$(INSTALL_DATA) $(PKG_FILES_DIR)/idmapd.conf $(TARGET_DIR)/etc/idmapd.conf
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/nfscommon.init $(TARGET_DIR)/etc/init.d/nfscommon
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/nfsserver.init $(TARGET_DIR)/etc/init.d/nfsserver
	$(UPDATE-RC.D) nfsserver defaults 13
	$(UPDATE-RC.D) nfscommon defaults 19 11
	chmod 0755 $(TARGET_DIR)/sbin/mount.nfs
	rm -f $(addprefix $(TARGET_DIR)/sbin/,mount.nfs4 umount.nfs umount.nfs4)
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/,mountstats nfsiostat)
	$(REMOVE)/$(NFS_UTILS_DIR)
	$(TOUCH)
