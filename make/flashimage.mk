#
# flashimage
#
flashimage:
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), hd51 bre2ze4k))
	$(MAKE) flash-image-multi-disk flash-image-multi-rootfs
endif
ifeq ($(BOXMODEL), hd60)
	$(MAKE) flash-image-hd60-multi-disk flash-image-hd60-multi-rootfs
endif
ifeq ($(BOXMODEL), hd61)
	$(MAKE) flash-image-hd61-multi-disk flash-image-hd61-multi-rootfs
endif
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), osmio4k osmio4kplus))
	$(MAKE) flash-image-osmio4k-multi-disk flash-image-osmio4k-multi-rootfs
endif
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), vuduo4k vusolo4k vuultimo4k vuuno4k vuuno4kse vuzero4k))
ifeq ($(VU_MULTIBOOT), 1)
	$(MAKE) flash-image-vu-multi-rootfs
else
	$(MAKE) flash-image-vu-rootfs
endif
endif
ifeq ($(BOXMODEL), vuduo)
	$(MAKE) flash-image-vuduo
endif
	$(TUXBOX_CUSTOMIZE)

# -----------------------------------------------------------------------------

ofgimage:
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), hd51 bre2ze4k))
	$(MAKE) ITYPE=ofg flash-image-multi-rootfs
endif
ifeq ($(BOXMODEL), hd60)
	$(MAKE) ITYPE=ofg flash-image-hd60-multi-rootfs
endif
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), osmio4k osmio4kplus))
	$(MAKE) ITYPE=ofg flash-image-osmio4k-multi-rootfs
endif
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), vuduo4k vusolo4k vuultimo4k vuuno4k vuuno4kse vuzero4k))
	$(MAKE) ITYPE=ofg flash-image-vu-rootfs
endif
	$(TUXBOX_CUSTOMIZE)

# -----------------------------------------------------------------------------

oi \
online-image:
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), hd51 bre2ze4k))
	$(MAKE) ITYPE=online flash-image-online
endif
ifeq ($(BOXMODEL), hd60)
	$(MAKE) ITYPE=online flash-image-hd60-online
endif
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), osmio4k osmio4kplus))
	$(MAKE) ITYPE=online flash-image-osmio4k-online
endif
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), vuduo4k vusolo4k vuultimo4k vuuno4k vuuno4kse vuzero4k))
	$(MAKE) ITYPE=online flash-image-vu-online
endif
	$(TUXBOX_CUSTOMIZE)

# -----------------------------------------------------------------------------

IMAGE_BUILD_DIR = $(BUILD_DIR)/image-build
ITYPE ?= usb

# -----------------------------------------------------------------------------

# hd51 / bre2ze4k
IMAGE_NAME = disk
BOOT_IMAGE = boot.img
IMAGE_LINK = $(IMAGE_NAME).ext4
IMAGE_ROOTFS_SIZE = 294912

# emmc image
EMMC_IMAGE_SIZE = 3817472
EMMC_IMAGE = $(IMAGE_BUILD_DIR)/$(IMAGE_NAME).img

BLOCK_SIZE = 512
BLOCK_SECTOR = 2

# partition offsets/sizes
IMAGE_ROOTFS_ALIGNMENT = 1024
BOOT_PARTITION_SIZE = 3072

KERNEL_PARTITION_OFFSET = $(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \+ $(BOOT_PARTITION_SIZE))
KERNEL_PARTITION_SIZE = 8192

ROOTFS_PARTITION_OFFSET = $(shell expr $(KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
ROOTFS_PARTITION_SIZE = 768000
ROOTFS_PARTITION_SIZE_NL = 1048576

SECOND_KERNEL_PARTITION_OFFSET = $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE))
SECOND_ROOTFS_PARTITION_OFFSET = $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

THIRD_KERNEL_PARTITION_OFFSET = $(shell expr $(SECOND_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE))
THIRD_ROOTFS_PARTITION_OFFSET = $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

FOURTH_KERNEL_PARTITION_OFFSET = $(shell expr $(THIRD_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE))
FOURTH_ROOTFS_PARTITION_OFFSET = $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))

LINUX_SWAP_PARTITION_OFFSET = $(shell expr $(FOURTH_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE))
LINUX_SWAP_PARTITION_SIZE = 204800

STORAGE_PARTITION_OFFSET = $(shell expr $(LINUX_SWAP_PARTITION_OFFSET) \+ $(LINUX_SWAP_PARTITION_SIZE))

SECOND_KERNEL_PARTITION_OFFSET_NL = $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_NL))

THIRD_KERNEL_PARTITION_OFFSET_NL = $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET_NL) \+ $(KERNEL_PARTITION_SIZE))

FOURTH_KERNEL_PARTITION_OFFSET_NL = $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET_NL) \+ $(KERNEL_PARTITION_SIZE))

MULTI_ROOTFS_PARTITION_OFFSET_NL = $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET_NL) \+ $(KERNEL_PARTITION_SIZE))
MULTI_ROOTFS_PARTITION_SIZE_NL = 2321408

LINUX_SWAP_PARTITION_OFFSET_NL = $(shell expr $(MULTI_ROOTFS_PARTITION_OFFSET_NL) \+ $(MULTI_ROOTFS_PARTITION_SIZE_NL))
LINUX_SWAP_PARTITION_SIZE_NL = 204800

STORAGE_PARTITION_OFFSET_NL = $(shell expr $(LINUX_SWAP_PARTITION_OFFSET_NL) \+ $(LINUX_SWAP_PARTITION_SIZE_NL))

flash-image-multi-disk: host-e2fsprogs
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	# Create a sparse image block
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(IMAGE_LINK) seek=$(shell expr $(IMAGE_ROOTFS_SIZE) \* $(BLOCK_SECTOR)) count=0 bs=$(BLOCK_SIZE)
ifeq ($(NEWLAYOUT), 1)
	$(HOST_DIR)/bin/mkfs.ext4 -F -m0 $(IMAGE_BUILD_DIR)/$(IMAGE_LINK) -d $(RELEASE_DIR)/..
else
	$(HOST_DIR)/bin/mkfs.ext4 -F -m0 $(IMAGE_BUILD_DIR)/$(IMAGE_LINK) -d $(RELEASE_DIR)
endif
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
	$(HOST_DIR)/bin/fsck.ext4 -pfD $(IMAGE_BUILD_DIR)/$(IMAGE_LINK) || [ $? -le 3 ]
	dd if=/dev/zero of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) count=0 seek=$(shell expr $(EMMC_IMAGE_SIZE) \* $(BLOCK_SECTOR))
	parted -s $(EMMC_IMAGE) mklabel gpt
	parted -s $(EMMC_IMAGE) unit KiB mkpart boot fat16 $(IMAGE_ROOTFS_ALIGNMENT) $(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \+ $(BOOT_PARTITION_SIZE))
ifeq ($(NEWLAYOUT), 1)
	parted -s $(EMMC_IMAGE) unit KiB mkpart linuxkernel $(KERNEL_PARTITION_OFFSET) $(shell expr $(KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart linuxrootfs ext4 $(ROOTFS_PARTITION_OFFSET) $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE_NL))
	parted -s $(EMMC_IMAGE) unit KiB mkpart linuxkernel2 $(SECOND_KERNEL_PARTITION_OFFSET_NL) $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET_NL) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart linuxkernel3 $(THIRD_KERNEL_PARTITION_OFFSET_NL) $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET_NL) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart linuxkernel4 $(FOURTH_KERNEL_PARTITION_OFFSET_NL) $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET_NL) \+ $(KERNEL_PARTITION_SIZE))
ifeq ($(NEWLAYOUT_SWAP), 1)
	parted -s $(EMMC_IMAGE) unit KiB mkpart userdata ext4 $(MULTI_ROOTFS_PARTITION_OFFSET_NL) $(shell expr $(MULTI_ROOTFS_PARTITION_OFFSET_NL) \+ $(MULTI_ROOTFS_PARTITION_SIZE_NL))
	parted -s $(EMMC_IMAGE) unit KiB mkpart swap linux-swap $(LINUX_SWAP_PARTITION_OFFSET_NL) $(shell expr $(LINUX_SWAP_PARTITION_OFFSET_NL) \+ $(LINUX_SWAP_PARTITION_SIZE_NL))
	parted -s $(EMMC_IMAGE) unit KiB mkpart storage ext4 $(STORAGE_PARTITION_OFFSET_NL) 100%
else
	parted -s $(EMMC_IMAGE) unit KiB mkpart userdata ext4 $(MULTI_ROOTFS_PARTITION_OFFSET_NL) 100%
endif
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(BOOT_IMAGE) bs=$(BLOCK_SIZE) count=$(shell expr $(BOOT_PARTITION_SIZE) \* $(BLOCK_SECTOR))
	mkfs.msdos -S 512 $(IMAGE_BUILD_DIR)/$(BOOT_IMAGE)
	echo "boot emmcflash0.linuxkernel  'root=/dev/mmcblk0p3 rootsubdir=linuxrootfs1 kernel=/dev/mmcblk0p2 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP
	echo "boot emmcflash0.linuxkernel  'root=/dev/mmcblk0p3 rootsubdir=linuxrootfs1 kernel=/dev/mmcblk0p2 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_1
	echo "boot emmcflash0.linuxkernel2 'root=/dev/mmcblk0p7 rootsubdir=linuxrootfs2 kernel=/dev/mmcblk0p4 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_2
	echo "boot emmcflash0.linuxkernel3 'root=/dev/mmcblk0p7 rootsubdir=linuxrootfs3 kernel=/dev/mmcblk0p5 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_3
	echo "boot emmcflash0.linuxkernel4 'root=/dev/mmcblk0p7 rootsubdir=linuxrootfs4 kernel=/dev/mmcblk0p6 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_4
else
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel1 $(KERNEL_PARTITION_OFFSET) $(shell expr $(KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs1 ext4 $(ROOTFS_PARTITION_OFFSET) $(shell expr $(ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel2 $(SECOND_KERNEL_PARTITION_OFFSET) $(shell expr $(SECOND_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs2 ext4 $(SECOND_ROOTFS_PARTITION_OFFSET) $(shell expr $(SECOND_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel3 $(THIRD_KERNEL_PARTITION_OFFSET) $(shell expr $(THIRD_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs3 ext4 $(THIRD_ROOTFS_PARTITION_OFFSET) $(shell expr $(THIRD_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart kernel4 $(FOURTH_KERNEL_PARTITION_OFFSET) $(shell expr $(FOURTH_KERNEL_PARTITION_OFFSET) \+ $(KERNEL_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart rootfs4 ext4 $(FOURTH_ROOTFS_PARTITION_OFFSET) $(shell expr $(FOURTH_ROOTFS_PARTITION_OFFSET) \+ $(ROOTFS_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart swap linux-swap $(LINUX_SWAP_PARTITION_OFFSET) $(shell expr $(LINUX_SWAP_PARTITION_OFFSET) \+ $(LINUX_SWAP_PARTITION_SIZE))
	parted -s $(EMMC_IMAGE) unit KiB mkpart storage ext4 $(STORAGE_PARTITION_OFFSET) $(shell expr $(EMMC_IMAGE_SIZE) \- 1024)
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(BOOT_IMAGE) bs=$(BLOCK_SIZE) count=$(shell expr $(BOOT_PARTITION_SIZE) \* $(BLOCK_SECTOR))
	mkfs.msdos -S 512 $(IMAGE_BUILD_DIR)/$(BOOT_IMAGE)
	echo "boot emmcflash0.kernel1 'root=/dev/mmcblk0p3 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP
	echo "boot emmcflash0.kernel1 'root=/dev/mmcblk0p3 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_1
	echo "boot emmcflash0.kernel2 'root=/dev/mmcblk0p5 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_2
	echo "boot emmcflash0.kernel3 'root=/dev/mmcblk0p7 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_3
	echo "boot emmcflash0.kernel4 'root=/dev/mmcblk0p9 rw rootwait $(BOXMODEL)_4.boxmode=1'" > $(IMAGE_BUILD_DIR)/STARTUP_4
endif
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_1 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_2 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_3 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_4 ::
	parted -s $(EMMC_IMAGE) unit KiB print
	dd conv=notrunc if=$(IMAGE_BUILD_DIR)/$(BOOT_IMAGE) of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(IMAGE_ROOTFS_ALIGNMENT) \* $(BLOCK_SECTOR))
	dd conv=notrunc if=$(KERNEL_OUTPUT_DTB) of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(KERNEL_PARTITION_OFFSET) \* $(BLOCK_SECTOR))
ifeq ($(NEWLAYOUT), 1)
	$(HOST_DIR)/bin/resize2fs $(IMAGE_BUILD_DIR)/$(IMAGE_LINK) $(ROOTFS_PARTITION_SIZE_NL)k
else
	$(HOST_DIR)/bin/resize2fs $(IMAGE_BUILD_DIR)/$(IMAGE_LINK) $(ROOTFS_PARTITION_SIZE)k
endif
	# Truncate on purpose
	dd if=$(IMAGE_BUILD_DIR)/$(IMAGE_LINK) of=$(EMMC_IMAGE) bs=$(BLOCK_SIZE) seek=$(shell expr $(ROOTFS_PARTITION_OFFSET) \* $(BLOCK_SECTOR)) count=$(shell expr $(IMAGE_ROOTFS_SIZE) \* $(BLOCK_SECTOR))
	mv $(IMAGE_BUILD_DIR)/$(IMAGE_NAME).img $(IMAGE_BUILD_DIR)/$(BOXMODEL)/

flash-image-multi-rootfs:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	cp $(KERNEL_OUTPUT_DTB) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/kernel.bin
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar . >/dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar
	echo "$(BOXMODEL)_DDT_usb_$(DATE)" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$(BOXMODEL)_multi_$(ITYPE)_$(DATE).zip $(BOXMODEL)/rootfs.tar.bz2 $(BOXMODEL)/kernel.bin $(BOXMODEL)/$(IMAGE_NAME).img $(BOXMODEL)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-online:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	cp $(KERNEL_OUTPUT_DTB) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/kernel.bin
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar . >/dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar
	echo "$(BOXMODEL)_DDT_usb_$(DATE)" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion
	$(CD) $(IMAGE_BUILD_DIR)/$(BOXMODEL); \
		tar -cvzf $(IMAGE_DIR)/$(BOXMODEL)_multi_$(ITYPE)_$(DATE).tgz rootfs.tar.bz2 kernel.bin imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

# -----------------------------------------------------------------------------

# armbox hd60
HD60_IMAGE_NAME = disk
HD60_BOOT_IMAGE = bootoptions.img
HD60_IMAGE_LINK = $(HD60_IMAGE_NAME).ext4

HD60_BOOTOPTIONS_PARTITION_SIZE = 32768
HD60_IMAGE_ROOTFS_SIZE = 1024M

HD60_BOOTARGS_DATE  = 20190420
HD60_BOOTARGS_SRC   = hd60-bootargs-$(HD60_BOOTARGS_DATE).zip
HD60_PARTITONS_DATE = 20190719
HD60_PARTITONS_SRC  = hd60-partitions-$(HD60_PARTITONS_DATE).zip
HD60_RECOVERY_DATE  = 20190719
HD60_RECOVERY_SRC   = hd60-recovery-$(HD60_RECOVERY_DATE).zip

$(ARCHIVE)/$(HD60_BOOTARGS_SRC):
	$(DOWNLOAD) http://downloads.mutant-digital.net/hd60/$(HD60_BOOTARGS_SRC)

$(ARCHIVE)/$(HD60_PARTITONS_SRC):
	$(DOWNLOAD) http://downloads.mutant-digital.net/hd60/$(HD60_PARTITONS_SRC)

$(ARCHIVE)/$(HD60_RECOVERY_SRC):
	$(DOWNLOAD) http://downloads.mutant-digital.net/hd60/$(HD60_RECOVERY_SRC)

flash-image-hd60-multi-disk: atools $(ARCHIVE)/$(HD60_BOOTARGS_SRC) $(ARCHIVE)/$(HD60_PARTITONS_SRC) $(ARCHIVE)/$(HD60_RECOVERY_SRC)
	# Create image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	unzip -o $(ARCHIVE)/$(HD60_BOOTARGS_SRC) -d $(IMAGE_BUILD_DIR)
	unzip -o $(ARCHIVE)/$(HD60_PARTITONS_SRC) -d $(IMAGE_BUILD_DIR)
	unzip -o $(ARCHIVE)/$(HD60_RECOVERY_SRC) -d $(IMAGE_BUILD_DIR)
	$(INSTALL_EXEC) $(IMAGE_BUILD_DIR)/bootargs-8gb.bin $(RELEASE_DIR)/usr/share/bootargs.bin
	$(INSTALL_EXEC) $(IMAGE_BUILD_DIR)/fastboot.bin $(RELEASE_DIR)/usr/share/fastboot.bin
	if [ -e $(RELEASE_DIR)/boot/logo.img ]; then \
		cp -rf $(RELEASE_DIR)/boot/logo.img $(IMAGE_BUILD_DIR)/$(BOXMODEL); \
	fi
	echo "$(BOXMODEL)_multi_usb_$(DATE)_recovery_emmc" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion
	$(HOST_DIR)/bin/make_ext4fs -l $(HD60_IMAGE_ROOTFS_SIZE) $(IMAGE_BUILD_DIR)/$(HD60_IMAGE_LINK) $(RELEASE_DIR)/..
	$(HOST_DIR)/bin/ext2simg -zv $(IMAGE_BUILD_DIR)/$(HD60_IMAGE_LINK) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.fastboot.gz
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD60_BOOT_IMAGE) bs=1024 count=$(HD60_BOOTOPTIONS_PARTITION_SIZE)
	mkfs.msdos -S 512 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD60_BOOT_IMAGE)
	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3BD000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP
	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs1 rootfstype=ext4 kernel=/dev/mmcblk0p19" >> $(IMAGE_BUILD_DIR)/STARTUP
	echo "bootcmd=setenv vfd_msg andr;setenv bootargs \$$(bootargs) \$$(bootargs_common); run bootcmd_android; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_ANDROID
	echo "bootargs=androidboot.selinux=disable androidboot.serialno=0123456789" >> $(IMAGE_BUILD_DIR)/STARTUP_ANDROID
	echo "bootcmd=setenv vfd_msg andr;setenv bootargs \$$(bootargs) \$$(bootargs_common); run bootcmd_android; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_ANDROID_DISABLE_LINUXSE
	echo "bootargs=androidboot.selinux=disable androidboot.serialno=0123456789" >> $(IMAGE_BUILD_DIR)/STARTUP_ANDROID_DISABLE_LINUXSE
	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3BD000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_1
	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs1 rootfstype=ext4 kernel=/dev/mmcblk0p19" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_1
	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3C5000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_2
	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs2 rootfstype=ext4 kernel=/dev/mmcblk0p20" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_2
	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3CD000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_3
	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs3 rootfstype=ext4 kernel=/dev/mmcblk0p21" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_3
	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3D5000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_4
	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs4 rootfstype=ext4 kernel=/dev/mmcblk0p22" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_4
	echo "bootcmd=setenv bootargs \$$(bootargs_common); mmc read 0 0x1000000 0x1000 0x9000; bootm 0x1000000" > $(IMAGE_BUILD_DIR)/STARTUP_RECOVERY
	echo "bootcmd=setenv bootargs \$$(bootargs_common); mmc read 0 0x1000000 0x1000 0x9000; bootm 0x1000000" > $(IMAGE_BUILD_DIR)/STARTUP_ONCE
	echo "imageurl https://raw.githubusercontent.com/oe-alliance/bootmenu/master/$(BOXMODEL)/images" > $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "# " >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "iface eth0" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "dhcp yes" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "# " >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "# for static config leave out 'dhcp yes' and add the following settings:" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "# " >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "#ip 192.168.178.10" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "#netmask 255.255.255.0" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "#gateway 192.168.178.1" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "#dns 192.168.178.1" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_ANDROID ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_ANDROID_DISABLE_LINUXSE ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_1 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_2 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_3 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_4 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_RECOVERY ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD60_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/bootmenu.conf ::
	mv $(IMAGE_BUILD_DIR)/bootargs-8gb.bin $(IMAGE_BUILD_DIR)/bootargs.bin
	mv $(IMAGE_BUILD_DIR)/$(BOXMODEL)/bootargs-8gb.bin $(IMAGE_BUILD_DIR)/$(BOXMODEL)/bootargs.bin
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/uImage
	rm -rf $(IMAGE_BUILD_DIR)/STARTUP*
	rm -rf $(IMAGE_BUILD_DIR)/*.txt
	rm -rf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/*.txt
	rm -rf $(IMAGE_BUILD_DIR)/$(HD60_IMAGE_LINK)
	echo "To access the recovery image press immediately by power-up the frontpanel button or hold down a remote button key untill the display says boot" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/recovery.txt
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$$(cat $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion).zip *
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-hd60-multi-rootfs:
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/uImage
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar . >/dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar
	echo "$(BOXMODEL)_multi_$(ITYPE)_$(DATE)_emmc" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion
	echo "$$(cat $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion).zip" > $(IMAGE_BUILD_DIR)/unforce_$(BOXMODEL).txt; \
	echo "Rename the unforce_$(BOXMODEL).txt to force_$(BOXMODEL).txt and move it to the root of your usb-stick" > $(IMAGE_BUILD_DIR)/force_$(BOXMODEL)_READ.ME; \
	echo "When you enter the recovery menu then it will force to install the image $$(cat $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion).zip in the image-slot1" >> $(IMAGE_BUILD_DIR)/force_$(BOXMODEL)_READ.ME; \
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$$(cat $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion).zip unforce_$(BOXMODEL).txt force_$(BOXMODEL)_READ.ME $(BOXMODEL)/rootfs.tar.bz2 $(BOXMODEL)/uImage $(BOXMODEL)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-hd60-online:
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/uImage
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar . >/dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar
	echo $(BOXMODEL)_DDT_usb_$(DATE) > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion
	$(CD) $(IMAGE_BUILD_DIR)/$(BOXMODEL); \
		tar -cvzf $(IMAGE_DIR)/$(BOXMODEL)_multi_$(ITYPE)_$(DATE).tgz rootfs.tar.bz2 uImage imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

# -----------------------------------------------------------------------------

# armbox hd61
HD61_IMAGE_NAME = disk
HD61_BOOT_IMAGE = bootoptions.img
HD61_IMAGE_LINK = $(HD61_IMAGE_NAME).ext4

HD61_BOOTOPTIONS_PARTITION_SIZE = 32768
HD61_IMAGE_ROOTFS_SIZE = 1024M

HD61_BOOTARGS_DATE  = 20190605
HD61_BOOTARGS_SRC   = hd61-bootargs-$(HD61_BOOTARGS_DATE).zip
HD61_PARTITONS_DATE = 20190719
HD61_PARTITONS_SRC  = hd61-partitions-$(HD61_PARTITONS_DATE).zip
HD61_RECOVERY_DATE  = 20190719
HD61_RECOVERY_SRC   = hd61-recovery-$(HD61_RECOVERY_DATE).zip

$(ARCHIVE)/$(HD61_BOOTARGS_SRC):
	$(DOWNLOAD) http://downloads.mutant-digital.net/hd61/$(HD61_BOOTARGS_SRC)

$(ARCHIVE)/$(HD61_PARTITONS_SRC):
	$(DOWNLOAD) http://downloads.mutant-digital.net/hd61/$(HD61_PARTITONS_SRC)

$(ARCHIVE)/$(HD61_RECOVERY_SRC):
	$(DOWNLOAD) http://downloads.mutant-digital.net/hd61/$(HD61_RECOVERY_SRC)

flash-image-hd61-multi-disk: atools $(ARCHIVE)/$(HD61_BOOTARGS_SRC) $(ARCHIVE)/$(HD61_PARTITONS_SRC) $(ARCHIVE)/$(HD61_RECOVERY_SRC)
	# Create image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	unzip -o $(ARCHIVE)/$(HD61_BOOTARGS_SRC) -d $(IMAGE_BUILD_DIR)
	unzip -o $(ARCHIVE)/$(HD61_PARTITONS_SRC) -d $(IMAGE_BUILD_DIR)
	unzip -o $(ARCHIVE)/$(HD61_RECOVERY_SRC) -d $(IMAGE_BUILD_DIR)
	$(INSTALL_EXEC) $(IMAGE_BUILD_DIR)/bootargs-8gb.bin $(RELEASE_DIR)/usr/share/bootargs.bin
	$(INSTALL_EXEC) $(IMAGE_BUILD_DIR)/fastboot.bin $(RELEASE_DIR)/usr/share/fastboot.bin
	if [ -e $(RELEASE_DIR)/boot/logo.img ]; then \
		cp -rf $(RELEASE_DIR)/boot/logo.img $(IMAGE_BUILD_DIR)/$(BOXMODEL); \
	fi
	echo "$(BOXMODEL)_multi_usb_$(DATE)_recovery_emmc" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion
	$(HOST_DIR)/bin/make_ext4fs -l $(HD61_IMAGE_ROOTFS_SIZE) $(IMAGE_BUILD_DIR)/$(HD61_IMAGE_LINK) $(RELEASE_DIR)/..
	$(HOST_DIR)/bin/ext2simg -zv $(IMAGE_BUILD_DIR)/$(HD61_IMAGE_LINK) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.fastboot.gz
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD61_BOOT_IMAGE) bs=1024 count=$(HD61_BOOTOPTIONS_PARTITION_SIZE)
	mkfs.msdos -S 512 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD61_BOOT_IMAGE)
	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3BD000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP
	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs1 rootfstype=ext4 kernel=/dev/mmcblk0p19" >> $(IMAGE_BUILD_DIR)/STARTUP
	echo "bootcmd=setenv vfd_msg andr;setenv bootargs \$$(bootargs) \$$(bootargs_common); run bootcmd_android; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_ANDROID
	echo "bootargs=androidboot.selinux=disable androidboot.serialno=0123456789" >> $(IMAGE_BUILD_DIR)/STARTUP_ANDROID
	echo "bootcmd=setenv vfd_msg andr;setenv bootargs \$$(bootargs) \$$(bootargs_common); run bootcmd_android; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_ANDROID_DISABLE_LINUXSE
	echo "bootargs=androidboot.selinux=disable androidboot.serialno=0123456789" >> $(IMAGE_BUILD_DIR)/STARTUP_ANDROID_DISABLE_LINUXSE
	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3BD000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_1
	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs1 rootfstype=ext4 kernel=/dev/mmcblk0p19" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_1
	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3C5000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_2
	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs2 rootfstype=ext4 kernel=/dev/mmcblk0p20" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_2
	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3CD000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_3
	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs3 rootfstype=ext4 kernel=/dev/mmcblk0p21" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_3
	echo "bootcmd=setenv bootargs \$$(bootargs) \$$(bootargs_common); mmc read 0 0x1000000 0x3D5000 0x8000; bootm 0x1000000; run bootcmd_fallback" > $(IMAGE_BUILD_DIR)/STARTUP_LINUX_4
	echo "bootargs=root=/dev/mmcblk0p23 rootsubdir=linuxrootfs4 rootfstype=ext4 kernel=/dev/mmcblk0p22" >> $(IMAGE_BUILD_DIR)/STARTUP_LINUX_4
	echo "bootcmd=setenv bootargs \$$(bootargs_common); mmc read 0 0x1000000 0x1000 0x9000; bootm 0x1000000" > $(IMAGE_BUILD_DIR)/STARTUP_RECOVERY
	echo "bootcmd=setenv bootargs \$$(bootargs_common); mmc read 0 0x1000000 0x1000 0x9000; bootm 0x1000000" > $(IMAGE_BUILD_DIR)/STARTUP_ONCE
	echo "imageurl https://raw.githubusercontent.com/oe-alliance/bootmenu/master/$(BOXMODEL)/images" > $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "# " >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "iface eth0" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "dhcp yes" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "# " >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "# for static config leave out 'dhcp yes' and add the following settings:" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "# " >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "#ip 192.168.178.10" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "#netmask 255.255.255.0" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "#gateway 192.168.178.1" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	echo "#dns 192.168.178.1" >> $(IMAGE_BUILD_DIR)/bootmenu.conf
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD61_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD61_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_ANDROID ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD61_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_ANDROID_DISABLE_LINUXSE ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD61_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_1 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD61_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_2 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD61_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_3 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD61_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_LINUX_4 ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD61_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/STARTUP_RECOVERY ::
	mcopy -i $(IMAGE_BUILD_DIR)/$(BOXMODEL)/$(HD61_BOOT_IMAGE) -v $(IMAGE_BUILD_DIR)/bootmenu.conf ::
	mv $(IMAGE_BUILD_DIR)/bootargs-8gb.bin $(IMAGE_BUILD_DIR)/bootargs.bin
	mv $(IMAGE_BUILD_DIR)/$(BOXMODEL)/bootargs-8gb.bin $(IMAGE_BUILD_DIR)/$(BOXMODEL)/bootargs.bin
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/uImage
	rm -rf $(IMAGE_BUILD_DIR)/STARTUP*
	rm -rf $(IMAGE_BUILD_DIR)/*.txt
	rm -rf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/*.txt
	rm -rf $(IMAGE_BUILD_DIR)/$(HD61_IMAGE_LINK)
	echo "To access the recovery image press immediately by power-up the frontpanel button or hold down a remote button key untill the display says boot" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/recovery.txt
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$$(cat $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion).zip *
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-hd61-multi-rootfs:
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/uImage
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar . >/dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar
	echo "$(BOXMODEL)_multi_$(ITYPE)_$(DATE)_emmc" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion
	echo "$$(cat $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion).zip" > $(IMAGE_BUILD_DIR)/unforce_$(BOXMODEL).txt; \
	echo "Rename the unforce_$(BOXMODEL).txt to force_$(BOXMODEL).txt and move it to the root of your usb-stick" > $(IMAGE_BUILD_DIR)/force_$(BOXMODEL)_READ.ME; \
	echo "When you enter the recovery menu then it will force to install the image $$(cat $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion).zip in the image-slot1" >> $(IMAGE_BUILD_DIR)/force_$(BOXMODEL)_READ.ME; \
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$$(cat $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion).zip unforce_$(BOXMODEL).txt force_$(BOXMODEL)_READ.ME $(BOXMODEL)/rootfs.tar.bz2 $(BOXMODEL)/uImage $(BOXMODEL)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-hd61-online:
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/uImage
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar . >/dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar
	echo $(BOXMODEL)_DDT_usb_$(DATE) > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion
	$(CD) $(IMAGE_BUILD_DIR)/$(BOXMODEL); \
		tar -cvzf $(IMAGE_DIR)/$(BOXMODEL)_multi_$(ITYPE)_$(DATE).tgz rootfs.tar.bz2 uImage imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

# -----------------------------------------------------------------------------

OSMIO4K_IMAGE_NAME = emmc
OSMIO4K_IMAGE_LINK = $(OSMIO4K_IMAGE_NAME).ext4

# emmc image
OSMIO4K_EMMC_IMAGE = $(IMAGE_BUILD_DIR)/$(OSMIO4K_IMAGE_NAME).img
OSMIO4K_EMMC_IMAGE_SIZE = 7634944

# partition offsets/sizes
OSMIO4K_IMAGE_ROOTFS_ALIGNMENT = 1024
OSMIO4K_BOOT_PARTITION_SIZE    = 3072
OSMIO4K_KERNEL_PARTITION_SIZE  = 8192
OSMIO4K_ROOTFS_PARTITION_SIZE  = 1898496

OSMIO4K_KERNEL1_PARTITION_OFFSET = $(shell expr $(OSMIO4K_IMAGE_ROOTFS_ALIGNMENT)   + $(OSMIO4K_BOOT_PARTITION_SIZE))
OSMIO4K_ROOTFS1_PARTITION_OFFSET = $(shell expr $(OSMIO4K_KERNEL1_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))

OSMIO4K_KERNEL2_PARTITION_OFFSET = $(shell expr $(OSMIO4K_ROOTFS1_PARTITION_OFFSET) + $(OSMIO4K_ROOTFS_PARTITION_SIZE))
OSMIO4K_ROOTFS2_PARTITION_OFFSET = $(shell expr $(OSMIO4K_KERNEL2_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))

OSMIO4K_KERNEL3_PARTITION_OFFSET = $(shell expr $(OSMIO4K_ROOTFS2_PARTITION_OFFSET) + $(OSMIO4K_ROOTFS_PARTITION_SIZE))
OSMIO4K_ROOTFS3_PARTITION_OFFSET = $(shell expr $(OSMIO4K_KERNEL3_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))

OSMIO4K_KERNEL4_PARTITION_OFFSET = $(shell expr $(OSMIO4K_ROOTFS3_PARTITION_OFFSET) + $(OSMIO4K_ROOTFS_PARTITION_SIZE))
OSMIO4K_ROOTFS4_PARTITION_OFFSET = $(shell expr $(OSMIO4K_KERNEL4_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))

flash-image-osmio4k-multi-disk: host-e2fsprogs
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	# Create a sparse image block
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/$(OSMIO4K_IMAGE_LINK) seek=$(shell expr $(OSMIO4K_EMMC_IMAGE_SIZE) \* 1024) count=0 bs=1
	$(HOST_DIR)/bin/mkfs.ext4 -F -m0 $(IMAGE_BUILD_DIR)/$(OSMIO4K_IMAGE_LINK) -d $(RELEASE_DIR)
	# Error codes 0-3 indicate successfull operation of fsck (no errors or errors corrected)
	$(HOST_DIR)/bin/fsck.ext4 -pfD $(IMAGE_BUILD_DIR)/$(OSMIO4K_IMAGE_LINK) || [ $? -le 3 ]
	dd if=/dev/zero of=$(OSMIO4K_EMMC_IMAGE) bs=1 count=0 seek=$(shell expr $(OSMIO4K_EMMC_IMAGE_SIZE) \* 1024)
	parted -s $(OSMIO4K_EMMC_IMAGE) mklabel gpt
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart boot fat16 $(OSMIO4K_IMAGE_ROOTFS_ALIGNMENT) $(shell expr $(OSMIO4K_IMAGE_ROOTFS_ALIGNMENT) + $(OSMIO4K_BOOT_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) set 1 boot on
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart kernel1 $(OSMIO4K_KERNEL1_PARTITION_OFFSET) $(shell expr $(OSMIO4K_KERNEL1_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart rootfs1 ext4 $(OSMIO4K_ROOTFS1_PARTITION_OFFSET) $(shell expr $(OSMIO4K_ROOTFS1_PARTITION_OFFSET) + $(OSMIO4K_ROOTFS_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart kernel2 $(OSMIO4K_KERNEL2_PARTITION_OFFSET) $(shell expr $(OSMIO4K_KERNEL2_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart rootfs2 ext4 $(OSMIO4K_ROOTFS2_PARTITION_OFFSET) $(shell expr $(OSMIO4K_ROOTFS2_PARTITION_OFFSET) + $(OSMIO4K_ROOTFS_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart kernel3 $(OSMIO4K_KERNEL3_PARTITION_OFFSET) $(shell expr $(OSMIO4K_KERNEL3_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart rootfs3 ext4 $(OSMIO4K_ROOTFS3_PARTITION_OFFSET) $(shell expr $(OSMIO4K_ROOTFS3_PARTITION_OFFSET) + $(OSMIO4K_ROOTFS_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart kernel4 $(OSMIO4K_KERNEL4_PARTITION_OFFSET) $(shell expr $(OSMIO4K_KERNEL4_PARTITION_OFFSET) + $(OSMIO4K_KERNEL_PARTITION_SIZE))
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB mkpart rootfs4 ext4 $(OSMIO4K_ROOTFS4_PARTITION_OFFSET) $(shell expr $(OSMIO4K_ROOTFS4_PARTITION_OFFSET) + $(OSMIO4K_ROOTFS_PARTITION_SIZE))
	dd if=/dev/zero of=$(IMAGE_BUILD_DIR)/boot.img bs=1024 count=$(OSMIO4K_BOOT_PARTITION_SIZE)
	mkfs.msdos -n boot -S 512 $(IMAGE_BUILD_DIR)/boot.img
	echo "setenv STARTUP \"boot emmcflash0.kernel1 'root=/dev/mmcblk1p3 rootfstype=ext4 rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP
	echo "setenv STARTUP \"boot emmcflash0.kernel1 'root=/dev/mmcblk1p3 rootfstype=ext4 rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_1
	echo "setenv STARTUP \"boot emmcflash0.kernel2 'root=/dev/mmcblk1p5 rootfstype=ext4 rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_2
	echo "setenv STARTUP \"boot emmcflash0.kernel3 'root=/dev/mmcblk1p7 rootfstype=ext4 rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_3
	echo "setenv STARTUP \"boot emmcflash0.kernel4 'root=/dev/mmcblk1p9 rootfstype=ext4 rootwait'\"" > $(IMAGE_BUILD_DIR)/STARTUP_4
	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP ::
	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_1 ::
	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_2 ::
	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_3 ::
	mcopy -i $(IMAGE_BUILD_DIR)/boot.img -v $(IMAGE_BUILD_DIR)/STARTUP_4 ::
	parted -s $(OSMIO4K_EMMC_IMAGE) unit KiB print
	dd conv=notrunc if=$(IMAGE_BUILD_DIR)/boot.img of=$(OSMIO4K_EMMC_IMAGE) seek=1 bs=$(shell expr $(OSMIO4K_IMAGE_ROOTFS_ALIGNMENT) \* 1024)
	dd conv=notrunc if=$(KERNEL_OUTPUT) of=$(OSMIO4K_EMMC_IMAGE) seek=1 bs=$(shell expr $(OSMIO4K_IMAGE_ROOTFS_ALIGNMENT) \* 1024 + $(OSMIO4K_BOOT_PARTITION_SIZE) \* 1024)
	$(HOST_DIR)/bin/resize2fs $(IMAGE_BUILD_DIR)/$(OSMIO4K_IMAGE_LINK) $(OSMIO4K_ROOTFS_PARTITION_SIZE)k
	# Truncate on purpose
	dd if=$(IMAGE_BUILD_DIR)/$(OSMIO4K_IMAGE_LINK) of=$(OSMIO4K_EMMC_IMAGE) seek=1 bs=$(shell expr $(OSMIO4K_IMAGE_ROOTFS_ALIGNMENT) \* 1024 + $(OSMIO4K_BOOT_PARTITION_SIZE) \* 1024 + $(OSMIO4K_KERNEL_PARTITION_SIZE) \* 1024)
	mv $(OSMIO4K_EMMC_IMAGE) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/

flash-image-osmio4k-multi-rootfs:
	# Create final USB-image
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/kernel.bin
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar . >/dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar
	echo "$(BOXMODEL)_DDT_usb_$(DATE)" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion
	echo "rename this file to 'force' to force an update without confirmation" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/noforce; \
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$(BOXMODEL)_multi_$(ITYPE)_$(DATE).zip $(BOXMODEL)/rootfs.tar.bz2 $(BOXMODEL)/kernel.bin $(BOXMODEL)/$(OSMIO4K_IMAGE_NAME).img $(BOXMODEL)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-osmio4k-online:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(BOXMODEL)
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(BOXMODEL)/kernel.bin
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar . >/dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(BOXMODEL)/rootfs.tar
	echo "$(BOXMODEL)_DDT_usb_$(DATE)" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/imageversion
	echo "rename this file to 'force' to force an update without confirmation" > $(IMAGE_BUILD_DIR)/$(BOXMODEL)/noforce; \
	$(CD) $(IMAGE_BUILD_DIR)/$(BOXMODEL); \
		tar -cvzf $(IMAGE_DIR)/$(BOXMODEL)_multi_$(ITYPE)_$(DATE).tgz rootfs.tar.bz2 kernel.bin imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

# -----------------------------------------------------------------------------

# armbox vu+
ifeq ($(BOXMODEL), vuduo4k)
VU_PREFIX = vuplus/duo4k
VU_INITRD = vmlinuz-initrd-7278b1
VU_FR     = echo "This file forces a reboot after the update." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/reboot.update
endif
ifeq ($(BOXMODEL), vusolo4k)
VU_PREFIX = vuplus/solo4k
VU_INITRD = vmlinuz-initrd-7366c0
VU_FR     = echo "This file forces a reboot after the update." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/reboot.update
endif
ifeq ($(BOXMODEL), vuultimo4k)
VU_PREFIX = vuplus/ultimo4k
VU_INITRD = vmlinuz-initrd-7445d0
VU_FR     = echo "This file forces a reboot after the update." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/reboot.update
endif
ifeq ($(BOXMODEL), vuuno4k)
VU_PREFIX = vuplus/uno4k
VU_INITRD = vmlinuz-initrd-7439b0
VU_FR     = echo "This file forces the update." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/force.update
endif
ifeq ($(BOXMODEL), vuuno4kse)
VU_PREFIX = vuplus/uno4kse
VU_INITRD = vmlinuz-initrd-7439b0
VU_FR     = echo This file forces a reboot after the update. > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/reboot.update
endif
ifeq ($(BOXMODEL), vuzero4k)
VU_PREFIX = vuplus/zero4k
VU_INITRD = vmlinuz-initrd-7260a0
VU_FR     = echo "This file forces the update." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/force.update
endif

flash-image-vu-multi-rootfs:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	cp $(BUILD_DIR)/$(VU_INITRD) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/initrd_auto.bin
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel1_auto.bin
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel2_auto.bin
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel3_auto.bin
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel4_auto.bin
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar . >/dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar
	mv $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar.bz2 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs1.tar.bz2
	$(VU_FR)
	echo "This file forces creating partitions." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/mkpart.update
	echo "Dummy for update." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel_auto.bin
	echo "Dummy for update." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar.bz2
	echo "$(BOXMODEL)_DDT_multi_usb_$(DATE)" > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/imageversion
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$(BOXMODEL)_multi_usb_$(DATE).zip $(VU_PREFIX)/rootfs*.tar.bz2 $(VU_PREFIX)/initrd_auto.bin $(VU_PREFIX)/kernel*_auto.bin $(VU_PREFIX)/*.update $(VU_PREFIX)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-vu-rootfs:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	cp $(BUILD_DIR)/$(VU_INITRD) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/initrd_auto.bin
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel_auto.bin
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar . >/dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar
	$(VU_FR)
	echo "This file forces creating partitions." > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/mkpart.update
	echo "$(BOXMODEL)_DDT_usb_$(DATE)" > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/imageversion
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$(BOXMODEL)_multi_$(ITYPE)_$(DATE).zip $(VU_PREFIX)/rootfs.tar.bz2 $(VU_PREFIX)/initrd_auto.bin $(VU_PREFIX)/kernel_auto.bin $(VU_PREFIX)/*.update $(VU_PREFIX)/imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

flash-image-vu-online:
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VU_PREFIX)
	cp $(KERNEL_OUTPUT) $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/kernel_auto.bin
	$(CD) $(RELEASE_DIR); \
		tar -cvf $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar . >/dev/null 2>&1; \
		bzip2 $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/rootfs.tar
	echo "$(BOXMODEL)_DDT_usb_$(DATE)" > $(IMAGE_BUILD_DIR)/$(VU_PREFIX)/imageversion
	$(CD) $(IMAGE_BUILD_DIR)/$(VU_PREFIX); \
		tar -cvzf $(IMAGE_DIR)/$(BOXMODEL)_multi_$(ITYPE)_$(DATE).tgz rootfs.tar.bz2 kernel_auto.bin imageversion
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)

# -----------------------------------------------------------------------------

# mipsbox vuduo
VUDUO_PREFIX = vuplus/duo

flash-image-vuduo: host-mtd-utils
	# Create final USB-image
	rm -rf $(IMAGE_BUILD_DIR) || true
	mkdir -p $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)
	touch $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/reboot.update
	gzip -9c < "$(KERNEL_OBJ_DIR)/vmlinux" > "$(KERNEL_OBJ_DIR)/kernel_cfe_auto.bin"
	cp $(KERNEL_OBJ_DIR)/kernel_cfe_auto.bin $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)
	mkfs.ubifs -r $(RELEASE_DIR) -o $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.ubi -m 2048 -e 126976 -c 4096 -F
	echo '[ubifs]' > $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'mode=ubi' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'image=$(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.ubi' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_id=0' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_type=dynamic' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_name=rootfs' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo 'vol_flags=autoresize' >> $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	ubinize -o $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.jffs2 -m 2048 -p 128KiB $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	rm -f $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/root_cfe_auto.ubi
	rm -f $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/ubinize.cfg
	echo "$(BOXMODEL)_DDT_usb_$(DATE)" > $(IMAGE_BUILD_DIR)/$(VUDUO_PREFIX)/imageversion
	$(CD) $(IMAGE_BUILD_DIR); \
		zip -r $(IMAGE_DIR)/$(BOXMODEL)_usb_$(DATE).zip $(VUDUO_PREFIX)*
	# cleanup
	rm -rf $(IMAGE_BUILD_DIR)
