#
# lcd4linux
#
LCD4LINUX_VER    = git
LCD4LINUX_DIR    = lcd4linux.$(LCD4LINUX_VER)
LCD4LINUX_SOURCE = lcd4linux.$(LCD4LINUX_VER)
LCD4LINUX_URL    = https://github.com/TangoCash

$(D)/lcd4linux: bootstrap ncurses libusb-compat libgd libusb libdpf
	$(START_BUILD)
	$(REMOVE)/$(LCD4LINUX_DIR)
	$(GET-GIT-SOURCE) $(LCD4LINUX_URL)/$(LCD4LINUX_SOURCE) $(ARCHIVE)/$(LCD4LINUX_SOURCE)
	$(CPDIR)/$(LCD4LINUX_DIR)
	$(CHDIR)/$(LCD4LINUX_DIR); \
		$(BUILD_ENV) ./bootstrap $(SILENT_OPT); \
		$(BUILD_ENV) ./configure $(CONFIGURE_OPTS) $(SILENT_OPT) \
			--prefix=/usr \
			--with-drivers='DPF,SamsungSPF,VUPLUS4K,PNG' \
			--with-plugins='all,!apm,!asterisk,!dbus,!dvb,!gps,!hddtemp,!huawei,!imon,!isdn,!kvv,!mpd,!mpris_dbus,!mysql,!pop3,!ppp,!python,!qnaplog,!raspi,!sample,!seti,!w1retap,!wireless,!xmms' \
			--with-ncurses=$(TARGET_LIB_DIR) \
			; \
		$(MAKE) vcs_version all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	cp -a $(PKG_FILES_DIR)/lcd4linux/* $(TARGET_DIR)/
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/lcd4linux.init $(TARGET_DIR)/etc/init.d/lcd4linux
	$(INSTALL_CONF) $(PKG_FILES_DIR)/lcd4linux.conf $(TARGET_DIR)/etc/
	$(REMOVE)/$(LCD4LINUX_DIR)
	$(TOUCH)
