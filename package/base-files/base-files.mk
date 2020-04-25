#
# base-files
#

$(D)/base-files: directories
	$(START_BUILD)
	$(INSTALL_EXEC) $(HELPERS_DIR)/update-rc.d $(TARGET_DIR)/usr/sbin/update-rc.d
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/alignment.sh $(TARGET_DIR)/etc/init.d/alignment.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/banner.sh $(TARGET_DIR)/etc/init.d/banner.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/bootmisc.sh $(TARGET_DIR)/etc/init.d/bootmisc.sh
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/camd $(TARGET_DIR)/etc/init.d/camd
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/camd_datefix $(TARGET_DIR)/etc/init.d/camd_datefix
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/checkroot.sh $(TARGET_DIR)/etc/init.d/checkroot.sh
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), bre2ze4k hd51 h7))
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/createswap.sh $(TARGET_DIR)/etc/init.d/createswap
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
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), bre2ze4k hd51 hd60 hd61 osmio4k osmio4kplus h7))
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/init.d/partitions-by-name $(TARGET_DIR)/etc/init.d/partitions-by-name
endif
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), bre2ze4k hd51 hd60 hd61 h7))
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
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/rc.local $(TARGET_DIR)/etc/rc.local
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/shells $(TARGET_DIR)/etc/shells
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/network/interfaces $(TARGET_DIR)/etc/network/interfaces
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/network/options $(TARGET_DIR)/etc/network/options
	$(INSTALL_DATA) $(PKG_FILES_DIR)/etc/default/volatiles/00_core $(TARGET_DIR)/etc/default/volatiles/00_core
	#
	# Create runlevel links
	#
	$(UPDATE-RC.D) banner.sh start 02 S .
	$(UPDATE-RC.D) sysfs.sh start 02 S .
	$(UPDATE-RC.D) mountall.sh start 03 S .
	$(UPDATE-RC.D) mdev start 04 S .
	$(UPDATE-RC.D) modutils.sh start 05 S .
	$(UPDATE-RC.D) alignment.sh start 06 S .
	$(UPDATE-RC.D) checkroot.sh start 06 S .
	$(UPDATE-RC.D) devpts.sh start 06 S .
	$(UPDATE-RC.D) modload.sh start 06 S .
	$(UPDATE-RC.D) hostname.sh start 39 S .
	$(UPDATE-RC.D) bootmisc.sh start 55 S .
	$(UPDATE-RC.D) sendsigs start 20 0 6 .
	$(UPDATE-RC.D) mountnfs.sh start 15 2 3 4 5 .
	$(UPDATE-RC.D) umountnfs.sh start 31 0 1 6 . stop 31 0 6 .
	$(UPDATE-RC.D) umountfs start 40 0 6 .
	$(UPDATE-RC.D) halt start 90 0 .
	$(UPDATE-RC.D) reboot start 90 6 .
	$(UPDATE-RC.D) networking start 01 2 3 4 5 . stop 80 0 1 6 .
	$(UPDATE-RC.D) rc.local start 99 2 3 4 5 .
	$(UPDATE-RC.D) camd start 50 2 3 4 5 . stop 50 0 1 6 .
	$(UPDATE-RC.D) read-only-rootfs-hook.sh start 29 S .
	$(UPDATE-RC.D) populate-volatile.sh start 37 S .
	$(UPDATE-RC.D) volatile-media.sh start 02 S .
	$(UPDATE-RC.D) urandom start 38 S 0 6 .
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), bre2ze4k hd51 hd60 hd61 osmio4k osmio4kplus h7))
	$(UPDATE-RC.D) resizerootfs start 7 S .
	$(UPDATE-RC.D) partitions-by-name start 04 S .
endif
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), bre2ze4k hd51 h7))
	$(UPDATE-RC.D) createswap start 98 3 .
endif
	#
	#
	#
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/etc/udev/mount-helper.sh $(TARGET_DIR)/etc/udev/mount-helper.sh
	# Inject machine specific blacklists into mount-helper
	perl -i -pe 's:(\@BLACKLISTED\@):$(MTD_BLACK):s' $(TARGET_DIR)/etc/udev/mount-helper.sh
	# Inject the /boot partition into /etc/fstab
	# or replace the placeholder @rootfs@ by the verbatim label "rootfs" (plus one tab)
	if [ -n "${MTD_BOOTFS}" ]; then \
		perl -i -pe 's:(\@rootfs\@):/dev/'$(MTD_BOOTFS)'\t/boot\t\t\tauto\t\tdefaults\t\t1\t1\nrootfs\t:s' $(TARGET_DIR)/etc/fstab; \
	else \
		perl -i -pe 's:(\@rootfs\@):rootfs\t:s' $(TARGET_DIR)/etc/fstab; \
	fi
	$(TOUCH)
