#
# base-files
#

ifeq ($(BOXMODEL), $(filter $(BOXMODEL), osmio4k osmio4kplus))
MTD_BLACK = mmcblk1
else
MTD_BLACK = mmcblk0
endif

$(D)/base-files: directories
	$(START_BUILD)
	$(INSTALL_EXEC) $(HELPERS_DIR)/update-rc.d $(TARGET_DIR)/usr/sbin/update-rc.d
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/alignment.sh $(TARGET_DIR)/etc/init.d/alignment.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/banner.sh $(TARGET_DIR)/etc/init.d/banner.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/bootmisc.sh $(TARGET_DIR)/etc/init.d/bootmisc.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/camd $(TARGET_DIR)/etc/init.d/camd
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/camd_datefix $(TARGET_DIR)/etc/init.d/camd_datefix
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/checkroot.sh $(TARGET_DIR)/etc/init.d/checkroot.sh
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), hd51 bre2ze4k))
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/createswap.sh $(TARGET_DIR)/etc/init.d/createswap.sh
endif
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/devpts.sh $(TARGET_DIR)/etc/init.d/devpts.sh
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/init.d/functions $(TARGET_DIR)/etc/init.d/functions
	pushd $(TARGET_DIR)/etc/init.d && ln -sf functions globals
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/halt $(TARGET_DIR)/etc/init.d/halt
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/hostname.sh $(TARGET_DIR)/etc/init.d/hostname.sh
#	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/hotplug.sh $(TARGET_DIR)/etc/init.d/hotplug.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/mdev $(TARGET_DIR)/etc/init.d/mdev
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/modload.sh $(TARGET_DIR)/etc/init.d/modload.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/modutils.sh $(TARGET_DIR)/etc/init.d/modutils.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/mountall.sh $(TARGET_DIR)/etc/init.d/mountall.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/mountnfs.sh $(TARGET_DIR)/etc/init.d/mountnfs.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/networking $(TARGET_DIR)/etc/init.d/networking
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), bre2ze4k hd51 hd60 hd61 osmio4k osmio4kplus))
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/partitions-by-name $(TARGET_DIR)/etc/init.d/partitions-by-name
endif
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), bre2ze4k hd51 hd60 hd61))
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/resizerootfs $(TARGET_DIR)/etc/init.d/resizerootfs
else ifeq ($(BOXMODEL), $(filter $(BOXMODEL), osmio4k osmio4kplus))
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/resizerootfs_mio $(TARGET_DIR)/etc/init.d/resizerootfs
endif
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/populate-volatile.sh $(TARGET_DIR)/etc/init.d/populate-volatile.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/rc.local $(TARGET_DIR)/etc/init.d/rc.local
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/read-only-rootfs-hook.sh $(TARGET_DIR)/etc/init.d/read-only-rootfs-hook.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/reboot $(TARGET_DIR)/etc/init.d/reboot
#	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/rmnologin.sh $(TARGET_DIR)/etc/init.d/rmnologin.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/sendsigs $(TARGET_DIR)/etc/init.d/sendsigs
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/single $(TARGET_DIR)/etc/init.d/single
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/sysfs.sh $(TARGET_DIR)/etc/init.d/sysfs.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/umountfs $(TARGET_DIR)/etc/init.d/umountfs
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/umountnfs.sh $(TARGET_DIR)/etc/init.d/umountnfs.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/urandom $(TARGET_DIR)/etc/init.d/urandom
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/volatile-media.sh $(TARGET_DIR)/etc/init.d/volatile-media.sh

	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/default/devpts $(TARGET_DIR)/etc/default/devpts
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/filesystems $(TARGET_DIR)/etc/filesystems
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/fstab $(TARGET_DIR)/etc/fstab
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/group $(TARGET_DIR)/etc/group
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/host.conf $(TARGET_DIR)/etc/host.conf
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/hosts $(TARGET_DIR)/etc/hosts
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/issue.net $(TARGET_DIR)/etc/issue.net
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/nsswitch.conf $(TARGET_DIR)/etc/nsswitch.conf
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/passwd $(TARGET_DIR)/etc/passwd
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/profile $(TARGET_DIR)/etc/profile
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/protocols $(TARGET_DIR)/etc/protocols
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/rc.local $(TARGET_DIR)/etc/rc.local
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/services $(TARGET_DIR)/etc/services
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/shells $(TARGET_DIR)/etc/shells

	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/network/interfaces $(TARGET_DIR)/etc/network/interfaces
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/network/options $(TARGET_DIR)/etc/network/options

	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/default/volatiles/00_core $(TARGET_DIR)/etc/default/volatiles/00_core

	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) banner.sh start 02 S .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) sysfs.sh start 02 S .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) mountall.sh start 03 S .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) mdev start 04 S .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) modutils.sh start 04 S .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) alignment.sh start 06 S .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) checkroot.sh start 06 S .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) devpts.sh start 06 S .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) modload.sh start 05 S .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) hostname.sh start 39 S .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) bootmisc.sh start 55 S .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) sendsigs start 20 0 6 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) mountnfs.sh start 15 2 3 4 5 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) umountnfs.sh start 31 0 1 6 . stop 31 0 6 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) umountfs start 40 0 6 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) halt start 90 0 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) reboot start 90 6 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) networking start 10 2 3 4 5 . stop 80 0 1 6 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) rc.local start 99 2 3 4 5 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) camd start 20 2 3 4 5 . stop 20 0 1 6 .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) read-only-rootfs-hook.sh start 29 S .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) populate-volatile.sh start 37 S .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) volatile-media.sh start 02 S .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) urandom start 38 S 0 6 .
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), bre2ze4k hd51 hd60 hd61 osmio4k osmio4kplus))
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) resizerootfs start 7 S .
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) partitions-by-name start 04 S .
endif
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), hd51 bre2ze4k))
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) createswap.sh start 98 3 .
endif
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/udev/mount-helper.sh $(TARGET_DIR)/etc/udev/mount-helper.sh
	# Inject machine specific blacklists into mount-helper
	perl -i -pe 's:(\@BLACKLISTED\@):${MTD_BLACK}:s' $(TARGET_DIR)/etc/udev/mount-helper.sh
	#  Inject the /boot partition into /etc/fstab
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), osmio4k osmio4kplus))
	printf "/dev/mmcblk1p1\t/boot\t\t\tauto\t\tdefaults\t\t1\t1\n" >> $(TARGET_DIR)/etc/fstab
else ifeq ($(BOXMODEL), vuduo4k)
	printf "/dev/mmcblk0p6\t/boot\t\t\tauto\t\tdefaults\t\t1\t1\n" >> $(TARGET_DIR)/etc/fstab
else ifeq ($(BOXMODEL), vuzero4k)
	printf "/dev/mmcblk0p4\t/boot\t\t\tauto\t\tdefaults\t\t1\t1\n" >> $(TARGET_DIR)/etc/fstab
else
	printf "/dev/mmcblk0p1\t/boot\t\t\tauto\t\tdefaults\t\t1\t1\n" >> $(TARGET_DIR)/etc/fstab
endif
	$(TOUCH)
