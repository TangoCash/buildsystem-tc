#
# sysvinit
#
SYSVINIT_VER    = 2.88dsf
SYSVINIT_DIR    = sysvinit-$(SYSVINIT_VER)
SYSVINIT_SOURCE = sysvinit-$(SYSVINIT_VER).tar.bz2
SYSVINIT_URL    = http://download.savannah.nongnu.org/releases/sysvinit

$(ARCHIVE)/$(SYSVINIT_SOURCE):
	$(DOWNLOAD) $(SYSVINIT_URL)/$(SYSVINIT_SOURCE)

SYSVINIT_PATCH  = \
	crypt-lib.patch \
	pidof-add-m-option.patch \
	realpath.patch \
	0001-include-sys-sysmacros.h-for-major-minor-defines-in-g.patch \
	0001-This-fixes-an-issue-that-clang-reports-about-mutlipl.patch

$(D)/sysvinit: bootstrap $(ARCHIVE)/$(SYSVINIT_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(SYSVINIT_DIR)
	$(UNTAR)/$(SYSVINIT_SOURCE)
	$(CHDIR)/$(SYSVINIT_DIR); \
		$(call apply_patches, $(SYSVINIT_PATCH)); \
		$(BUILD_ENV) \
		$(MAKE) -C src SULOGINLIBS=-lcrypt; \
		$(MAKE) install ROOT=$(TARGET_DIR) MANDIR=/.remove
	$(INSTALL_DATA) $(PKG_FILES_DIR)/inittab $(TARGET_DIR)/etc/inittab
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/autologin $(TARGET_DIR)/bin/autologin
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/rc $(TARGET_DIR)/etc/init.d
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/rcS $(TARGET_DIR)/etc/init.d
	$(INSTALL_DATA) $(PKG_FILES_DIR)/rcS-default $(TARGET_DIR)/etc/default/rcS
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/service $(TARGET_DIR)/sbin/
#	$(INSTALL_EXEC) $(PKG_FILES_DIR)/bootlogd.init $(TARGET_DIR)/etc/init.d/bootlogd
#	$(INSTALL_DATA) $(PKG_FILES_DIR)/volatiles.01_bootlogd $(TARGET_DIR)/etc/default/volatiles/01_bootlogd
#	ln -sf bootlogd $(TARGET_DIR)/etc/init.d/stop-bootlogd
#	$(UPDATE-RC.D) bootlogd start 07 S .
#	$(UPDATE-RC.D) stop-bootlogd start 99 2 3 4 5 .
	rm -f $(addprefix $(TARGET_DIR)/sbin/,fstab-decode runlevel telinit)
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,lastb)
	$(REMOVE)/$(SYSVINIT_DIR)
	$(TOUCH)
