#
# coreutils
#
COREUTILS_VER    = 8.30
COREUTILS_DIR    = coreutils-$(COREUTILS_VER)
COREUTILS_SOURCE = coreutils-$(COREUTILS_VER).tar.xz
COREUTILS_URL    = https://ftp.gnu.org/gnu/coreutils

$(ARCHIVE)/$(COREUTILS_SOURCE):
	$(DOWNLOAD) $(COREUTILS_URL)/$(COREUTILS_SOURCE)

$(D)/coreutils: bootstrap openssl $(ARCHIVE)/$(COREUTILS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(COREUTILS_DIR)
	$(UNTAR)/$(COREUTILS_SOURCE)
	$(CHDIR)/$(COREUTILS_DIR); \
		export fu_cv_sys_stat_statfs2_bsize=yes; \
		$(CONFIGURE) \
			--prefix=/usr \
			--bindir=/bin \
			--mandir=/.remove \
			--infodir=/.remove \
			--localedir=/.remove/locale \
			--enable-largefile \
			--enable-silent-rules \
			--disable-xattr \
			--disable-libcap \
			--disable-acl \
			--without-gmp \
			--without-selinux \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(COREUTILS_DIR)
	$(TOUCH)
