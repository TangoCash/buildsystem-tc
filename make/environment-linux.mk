#
# set up linux environment for other makefiles
#
# -----------------------------------------------------------------------------

# translate toolchain arch to kernel arch
ifeq ($(BOXARCH), arm)
KERNEL_ARCH = arm
else ifeq ($(BOXARCH), aarch64)
KERNEL_ARCH = arm64
else ifeq ($(BOXARCH), mips)
KERNEL_ARCH = mips
endif

# -----------------------------------------------------------------------------

KERNEL_OBJ         = linux-$(KERNEL_VER)-kernel-obj
KERNEL_DTB         = $(BUILD_DIR)/$(KERNEL_OBJ)/arch/$(KERNEL_ARCH)/boot/dts/$(KERNEL_DTB_VER)
KERNEL_MODULES     = linux-$(KERNEL_VER)-modules
KERNEL_MODULES_DIR = $(BUILD_DIR)/linux-$(KERNEL_VER)-modules/lib/modules/$(KERNEL_VER)
TARGET_MODULES_DIR = $(TARGET_DIR)/lib/modules/$(KERNEL_VER)

KERNEL_UIMAGE      = $(BUILD_DIR)/$(KERNEL_OBJ)/arch/$(KERNEL_ARCH)/boot/uImage
KERNEL_ZIMAGE      = $(BUILD_DIR)/$(KERNEL_OBJ)/arch/$(KERNEL_ARCH)/boot/zImage
KERNEL_IMAGE_GZ    = $(BUILD_DIR)/$(KERNEL_OBJ)/arch/$(KERNEL_ARCH)/boot/Image.gz
KERNEL_ZIMAGE_DTB  = $(BUILD_DIR)/$(KERNEL_OBJ)/arch/$(KERNEL_ARCH)/boot/zImage_dtb

# -----------------------------------------------------------------------------

depmod:
	PATH=$(PATH):/sbin:/usr/sbin depmod -b $(TARGET_DIR) $(KERNEL_VER)

KERNEL_MAKEVARS = \
	ARCH=$(KERNEL_ARCH) \
	CROSS_COMPILE=$(TARGET_CROSS) \
	INSTALL_MOD_PATH=$(BUILD_DIR)/$(KERNEL_MODULES) \
	O=$(BUILD_DIR)/$(KERNEL_OBJ)

# Compatibility variables
KERNEL_MAKEVARS += \
	KDIR=$(KERNEL_DIR) \
	KSRC=$(KERNEL_DIR) \
	SRC=$(KERNEL_DIR) \
	KERNDIR=$(KERNEL_DIR) \
	KERNEL_SRC=$(KERNEL_DIR) \
	KERNEL_SOURCE=${KERNEL_DIR} \
	LINUX_SRC=$(KERNEL_DIR) \
	KVER=$(KERNEL_VER) \
	KERNEL_VERSION=$(KERNEL_VER)

# -----------------------------------------------------------------------------

ifeq ($(BOXMODEL), bre2ze4k)
KERNEL_VER         = 4.10.12
KERNEL_SOURCE      = linux-$(KERNEL_VER)-arm.tar.gz
KERNEL_URL         = http://downloads.mutant-digital.net
KERNEL_CONFIG      = bre2ze4k_defconfig
KERNEL_DIR         = $(BUILD_DIR)/linux-$(KERNEL_VER)
KERNEL_DTB_VER     = bcm7445-bcm97445svmb.dtb
KERNEL_BUILD_IMAGE = zImage
KERNEL_PATCHES     = $(BRE2ZE4K_PATCHES)
endif

ifeq ($(BOXMODEL), hd51)
KERNEL_VER         = 4.10.12
KERNEL_SOURCE      = linux-$(KERNEL_VER)-arm.tar.gz
KERNEL_URL         = http://downloads.mutant-digital.net
KERNEL_CONFIG      = hd51_defconfig
KERNEL_DIR         = $(BUILD_DIR)/linux-$(KERNEL_VER)
KERNEL_DTB_VER     = bcm7445-bcm97445svmb.dtb
KERNEL_BUILD_IMAGE = zImage
KERNEL_PATCHES     = $(HD51_PATCHES)
endif

ifeq ($(BOXMODEL), hd60)
KERNEL_VER         = 4.4.35
KERNEL_DATE        = 20181228
KERNEL_SOURCE      = linux-$(KERNEL_VER)-$(KERNEL_DATE)-arm.tar.gz
KERNEL_URL         = http://downloads.mutant-digital.net
KERNEL_CONFIG      = hd60_defconfig
KERNEL_DIR         = $(BUILD_DIR)/linux-$(KERNEL_VER)
KERNEL_DTB_VER     = hi3798mv200.dtb
KERNEL_BUILD_IMAGE = uImage
KERNEL_PATCHES     = $(HD60_PATCHES)
endif

ifeq ($(BOXMODEL), vusolo4k)
KERNEL_VER         = 3.14.28-1.8
KERNEL_SOURCE_VER  = 3.14-1.8
KERNEL_SOURCE      = stblinux-$(KERNEL_SOURCE_VER).tar.bz2
KERNEL_URL         = http://archive.vuplus.com/download/kernel
ifeq ($(VU_MULTIBOOT), 1)
KERNEL_CONFIG      = vusolo4k_defconfig_multi
else
KERNEL_CONFIG      = vusolo4k_defconfig
endif
KERNEL_DIR         = $(BUILD_DIR)/linux
KERNEL_DTB_VER     =
KERNEL_BUILD_IMAGE = zImage
KERNEL_PATCHES     = $(VUSOLO4K_PATCHES)
endif

ifeq ($(BOXMODEL), vuduo4k)
KERNEL_VER         = 4.1.45-1.17
KERNEL_SOURCE_VER  = 4.1-1.17
KERNEL_SOURCE      = stblinux-${KERNEL_SOURCE_VER}.tar.bz2
KERNEL_URL         = http://archive.vuplus.com/download/kernel
ifeq ($(VU_MULTIBOOT), 1)
KERNEL_CONFIG      = vuduo4k_defconfig_multi
else
KERNEL_CONFIG      = vuduo4k_defconfig
endif
KERNEL_DIR         = $(BUILD_DIR)/linux
KERNEL_DTB_VER     =
KERNEL_BUILD_IMAGE = zImage
KERNEL_PATCHES     = $(VUDUO4K_PATCHES)
endif

ifeq ($(BOXMODEL), vuultimo4k)
KERNEL_VER         = 3.14.28-1.12
KERNEL_SOURCE_VER  = 3.14-1.12
KERNEL_SOURCE      = stblinux-${KERNEL_SOURCE_VER}.tar.bz2
KERNEL_URL         = http://archive.vuplus.com/download/kernel
ifeq ($(VU_MULTIBOOT), 1)
KERNEL_CONFIG      = vuultimo4k_defconfig_multi
else
KERNEL_CONFIG      = vuultimo4k_defconfig
endif
KERNEL_DIR         = $(BUILD_DIR)/linux
KERNEL_DTB_VER     =
KERNEL_BUILD_IMAGE = zImage
KERNEL_PATCHES     = $(VUULTIMO4K_PATCHES)
endif

ifeq ($(BOXMODEL), vuzero4k)
KERNEL_VER         = 4.1.20-1.9
KERNEL_SOURCE_VER  = 4.1-1.9
KERNEL_SOURCE      = stblinux-${KERNEL_SOURCE_VER}.tar.bz2
KERNEL_URL         = http://archive.vuplus.com/download/kernel
ifeq ($(VU_MULTIBOOT), 1)
KERNEL_CONFIG      = vuzero4k_defconfig_multi
else
KERNEL_CONFIG      = vuzero4k_defconfig
endif
KERNEL_DIR         = $(BUILD_DIR)/linux
KERNEL_DTB_VER     =
KERNEL_BUILD_IMAGE = zImage
KERNEL_PATCHES     = $(VUZERO4K_PATCHES)
endif

ifeq ($(BOXMODEL), vuduo)
KERNEL_VER         = 3.9.6
KERNEL_SOURCE      = stblinux-$(KERNEL_VER).tar.bz2
KERNEL_URL         = http://archive.vuplus.com/download/kernel
KERNEL_CONFIG      = vuduo_defconfig
KERNEL_DIR         = $(BUILD_DIR)/linux
KERNEL_DTB_VER     =
KERNEL_BUILD_IMAGE = vmlinux
KERNEL_PATCHES     = $(VUDUO4K_PATCHES)
endif

ifeq ($(BOXMODEL), osmio4k)
KERNEL_VER         = 5.3.0
KERNEL_SOURCE_VER  = 5.3
KERNEL_SOURCE      = linux-edision-$(KERNEL_SOURCE_VER).tar.gz
KERNEL_URL         = http://source.mynonpublic.com/edision
KERNEL_CONFIG      = osmio4kplus_defconfig
KERNEL_DIR         = $(BUILD_DIR)/linux-brcmstb-$(KERNEL_SOURCE_VER)
KERNEL_DTB_VER     =
KERNEL_BUILD_IMAGE = Image.gz
KERNEL_PATCHES     = $(OSMIO4KPLUS_PATCHES)
endif

ifeq ($(BOXMODEL), osmio4kplus)
KERNEL_VER         = 5.3.0
KERNEL_SOURCE_VER  = 5.3
KERNEL_SOURCE      = linux-edision-$(KERNEL_SOURCE_VER).tar.gz
KERNEL_URL         = http://source.mynonpublic.com/edision
KERNEL_CONFIG      = osmio4kplus_defconfig
KERNEL_DIR         = $(BUILD_DIR)/linux-brcmstb-$(KERNEL_SOURCE_VER)
KERNEL_DTB_VER     =
KERNEL_BUILD_IMAGE = Image.gz
KERNEL_PATCHES     = $(OSMIO4KPLUS_PATCHES)
endif

$(ARCHIVE)/$(KERNEL_SOURCE):
	$(DOWNLOAD) $(KERNEL_URL)/$(KERNEL_SOURCE)
