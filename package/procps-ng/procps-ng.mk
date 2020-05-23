#
# procps-ng
#
PROCPS_NG_VER    = 3.3.16
PROCPS_NG_DIR    = procps-ng-$(PROCPS_NG_VER)
PROCPS_NG_SOURCE = procps-ng-$(PROCPS_NG_VER).tar.xz
PROCPS_NG_URL    = http://sourceforge.net/projects/procps-ng/files/Production

$(ARCHIVE)/$(PROCPS_NG_SOURCE):
	$(DOWNLOAD) $(PROCPS_NG_URL)/$(PROCPS_NG_SOURCE)

PROCPS_NG_PATCH  = \
	no-tests-docs.patch

BINDIR_PROGS = free pgrep pkill pmap pwdx slabtop skill snice tload top uptime vmstat w

$(D)/procps-ng: bootstrap ncurses $(ARCHIVE)/$(PROCPS_NG_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(PROCPS_NG_DIR)
	$(UNTAR)/$(PROCPS_NG_SOURCE)
	$(CHDIR)/$(PROCPS_NG_DIR); \
		$(call apply_patches, $(PROCPS_NG_PATCH)); \
		export ac_cv_func_malloc_0_nonnull=yes; \
		export ac_cv_func_realloc_0_nonnull=yes; \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--bindir=/bin \
			--sbindir=/sbin \
			--mandir=/.remove \
			--docdir=/.remove \
			--datarootdir=/.remove \
			--enable-skill \
			--disable-modern-top \
			--without-systemd \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
		for i in $(BINDIR_PROGS); do \
			mv $(TARGET_DIR)/bin/$$i $(TARGET_DIR)/usr/bin/$$i; \
		done
	$(INSTALL_DATA) $(PKG_FILES_DIR)/sysctl.conf $(TARGET_DIR)/etc/sysctl.conf
	$(call adapted-etc-files, $(PROCPS_NG_ADAPTED_ETC_FILES))
	$(REWRITE_LIBTOOL)/libprocps.la
	$(REMOVE)/$(PROCPS_NG_DIR)
	$(TOUCH)
