#
# busybox
#
BUSYBOX_VER    = 1.31.1
BUSYBOX_DIR    = busybox-$(BUSYBOX_VER)
BUSYBOX_SOURCE = busybox-$(BUSYBOX_VER).tar.bz2
BUSYBOX_URL    = https://busybox.net/downloads

$(ARCHIVE)/$(BUSYBOX_SOURCE):
	$(DOWNLOAD) $(BUSYBOX_URL)/$(BUSYBOX_SOURCE)

BUSYBOX_PATCH  = \
	0001-Prevent-telnet-connections-from-the-internet-to-the.patch \
	0002-Extended-network-interfaces-support.patch \
	0003-Revert-ip-fix-ip-oneline-a.patch \
	use_ipv6_when_ipv4_unroutable.patch \
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
	@if grep -q "CONFIG_CROND=y" $(BUILD_DIR)/$(BUSYBOX_DIR)/.config; then \
		mkdir -p $(TARGET_DIR)/etc/cron/crontabs; \
		$(INSTALL_EXEC) $(PKG_FILES_DIR)/cron.busybox $(TARGET_DIR)/etc/init.d/cron.busybox; \
		$(UPDATE-RC.D) cron.busybox start 90 2 3 4 5 . stop 60 0 1 6 .; \
	fi
	@if grep -q "CONFIG_INETD=y" $(BUILD_DIR)/$(BUSYBOX_DIR)/.config; then \
		$(INSTALL_DATA) $(PKG_FILES_DIR)/inetd.conf $(TARGET_DIR)/etc/inetd.conf; \
		$(INSTALL_EXEC) $(PKG_FILES_DIR)/inetd.busybox $(TARGET_DIR)/etc/init.d/inetd.busybox; \
	fi
	@if grep -q "CONFIG_MDEV=y" $(BUILD_DIR)/$(BUSYBOX_DIR)/.config; then \
		$(INSTALL_DATA) $(PKG_FILES_DIR)/mdev.conf $(TARGET_DIR)/etc/mdev.conf; \
	fi
	@if grep -q "CONFIG_SYSLOGD=y" $(BUILD_DIR)/$(BUSYBOX_DIR)/.config; then \
		$(INSTALL_DATA) $(PKG_FILES_DIR)/syslog-startup.conf $(TARGET_DIR)/etc/syslog-startup.conf; \
		$(INSTALL_EXEC) $(PKG_FILES_DIR)/syslog.busybox $(TARGET_DIR)/etc/init.d/syslog.busybox; \
		$(UPDATE-RC.D) syslog.busybox start 20 2 3 4 5 . stop 20 0 1 6 .; \
	fi
	@if grep -q "CONFIG_FEATURE_TELNETD_STANDALONE=y" $(BUILD_DIR)/$(BUSYBOX_DIR)/.config; then \
		$(INSTALL_EXEC) $(PKG_FILES_DIR)/telnetd.busybox $(TARGET_DIR)/etc/init.d/telnetd.busybox; \
		$(UPDATE-RC.D) telnetd.busybox start 20 2 3 4 5 . stop 20 0 1 6 .; \
	fi
	@if grep -q "CONFIG_UDHCPC=y" $(BUILD_DIR)/$(BUSYBOX_DIR)/.config; then \
		mkdir -p $(TARGET_DIR)/etc/udhcpc.d; \
		$(INSTALL_EXEC) $(PKG_FILES_DIR)/55ntp $(TARGET_DIR)/etc/udhcpc.d/55ntp; \
		$(INSTALL_EXEC) $(PKG_FILES_DIR)/50default $(TARGET_DIR)/etc/udhcpc.d/50default; \
		$(INSTALL_EXEC) -D $(PKG_FILES_DIR)/default.script $(TARGET_SHARE_DIR)/udhcpc/default.script; \
	fi
#	$(UPDATE-RC.D) inetd.busybox start 20 2 3 4 5 . stop 20 0 1 6 .
	$(REMOVE)/$(BUSYBOX_DIR)
	$(TOUCH)

busybox-config: bootstrap $(ARCHIVE)/$(BUSYBOX_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(BUSYBOX_DIR)
	$(UNTAR)/$(BUSYBOX_SOURCE)
	$(CHDIR)/$(BUSYBOX_DIR); \
		$(INSTALL_DATA) $(subst -config,,$(PKG_FILES_DIR))/busybox.config .config; \
		make menuconfig
