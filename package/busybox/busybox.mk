#
# busybox
#
BUSYBOX_VER    = 1.31.0
BUSYBOX_DIR    = busybox-$(BUSYBOX_VER)
BUSYBOX_SOURCE = busybox-$(BUSYBOX_VER).tar.bz2
BUSYBOX_URL    = https://busybox.net/downloads

$(ARCHIVE)/$(BUSYBOX_SOURCE):
	$(DOWNLOAD) $(BUSYBOX_URL)/$(BUSYBOX_SOURCE)

BUSYBOX_PATCH  = \
	fix-config-header.patch \
	fix-partition-size.patch \
	insmod-hack.patch \
	mount_single_uuid.patch

BUSYBOX_MAKE_OPTS = \
	$(MAKE_OPTS) \
	CFLAGS_EXTRA="$(TARGET_CFLAGS)" \
	EXTRA_LDFLAGS="$(TARGET_LDFLAGS)" \
	CONFIG_PREFIX="$(TARGET_DIR)"

$(D)/busybox: bootstrap $(ARCHIVE)/$(BUSYBOX_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(BUSYBOX_DIR)
	$(UNTAR)/$(BUSYBOX_SOURCE)
	$(CHDIR)/$(BUSYBOX_DIR); \
		$(call apply_patches, $(BUSYBOX_PATCH)); \
		$(INSTALL_DATA) $(PKG_FILES_DIR)/busybox.config .config; \
		sed -i -e 's#^CONFIG_PREFIX.*#CONFIG_PREFIX="$(TARGET_DIR)"#' .config; \
		$(BUSYBOX_MAKE_OPTS) $(MAKE) busybox; \
		$(BUSYBOX_MAKE_OPTS) $(MAKE) install-noclobber
	mkdir -p $(TARGET_DIR)/etc/udhcpc.d
	mkdir -p $(TARGET_DIR)/etc/cron/crontabs
	$(INSTALL_DATA) $(PKG_FILES_DIR)/mdev.conf $(TARGET_DIR)/etc/mdev.conf
	$(INSTALL_DATA) $(PKG_FILES_DIR)/inetd.conf $(TARGET_DIR)/etc/inetd.conf
	$(INSTALL_DATA) $(PKG_FILES_DIR)/syslog-startup.conf $(TARGET_DIR)/etc/syslog-startup.conf
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/autologin $(TARGET_DIR)/bin/autologin
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/cron.busybox $(TARGET_DIR)/etc/init.d/cron.busybox
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/inetd.busybox $(TARGET_DIR)/etc/init.d/inetd.busybox
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/telnetd.busybox $(TARGET_DIR)/etc/init.d/telnetd.busybox
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/syslog.busybox $(TARGET_DIR)/etc/init.d/syslog.busybox
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/55ntp $(TARGET_DIR)/etc/udhcpc.d/55ntp
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/50default $(TARGET_DIR)/etc/udhcpc.d/50default
	$(INSTALL_EXEC) -D $(PKG_FILES_DIR)/default.script $(TARGET_SHARE_DIR)/udhcpc/default.script
#	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) inetd.busybox start 20 2 3 4 5 . stop 20 0 1 6 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) telnetd.busybox start 20 2 3 4 5 . stop 20 0 1 6 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) syslog.busybox start 20 2 3 4 5 . stop 20 0 1 6 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) cron.busybox start 90 2 3 4 5 . stop 60 0 1 6 .
	$(REMOVE)/$(BUSYBOX_DIR)
	$(TOUCH)

busybox-config: bootstrap $(ARCHIVE)/$(BUSYBOX_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(BUSYBOX_DIR)
	$(UNTAR)/$(BUSYBOX_SOURCE)
	$(CHDIR)/$(BUSYBOX_DIR); \
		$(INSTALL_DATA) $(subst -config,,$(PKG_FILES_DIR))/busybox.config .config; \
		make menuconfig
