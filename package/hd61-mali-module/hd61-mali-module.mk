#
# hd61-mali-module
#
HD61_MALI_MODULE_VER    = DX910-SW-99002-r7p0-00rel0
HD61_MALI_MODULE        = $(HD61_MALI_MODULE_VER)
HD61_MALI_MODULE_SOURCE = $(HD61_MALI_MODULE_VER).tgz
HD61_MALI_MODULE_URL    = https://developer.arm.com/-/media/Files/downloads/mali-drivers/kernel/mali-utgard-gpu

# currently same as hd60
#$(ARCHIVE)/$(HD61_MALI_MODULE_SOURCE):
#	$(DOWNLOAD) $(HD61_MALI_MODULE_URL)/$(HD61_MALI_MODULE_SOURCE)

HD61_MALI_MODULE_PATCH = \
	hi3798mv200-support.patch

HD61_MALI_MODULE_MAKEVARS = \
	M=$(BUILD_DIR)/$(HD61_MALI_MODULE)/driver/src/devicedrv/mali \
	EXTRA_CFLAGS=" \
	-DCONFIG_MALI_DVFS=y \
	-DCONFIG_GPU_AVS_ENABLE=y" \
	CONFIG_MALI_SHARED_INTERRUPTS=y \
	CONFIG_MALI400=m \
	CONFIG_MALI450=y \
	CONFIG_MALI_DVFS=y \
	CONFIG_GPU_AVS_ENABLE=y

$(D)/hd61-mali-module: bootstrap kernel hd61-libgles-header $(ARCHIVE)/$(HD61_MALI_MODULE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HD61_MALI_MODULE)
	$(UNTAR)/$(HD61_MALI_MODULE_SOURCE)
	$(CHDIR)/$(HD61_MALI_MODULE); \
		$(call apply_patches, $(HD61_MALI_MODULE_PATCH)); \
		$(MAKE) -C $(KERNEL_DIR) $(KERNEL_MAKEVARS) \
		$(HD61_MALI_MODULE_MAKEVARS); \
		$(MAKE) -C $(KERNEL_DIR) $(KERNEL_MAKEVARS) \
		M=$(BUILD_DIR)/$(HD61_MALI_MODULE)/driver/src/devicedrv/mali \
		$(HD61_MALI_MODULE_MAKEVARS) \
		INSTALL_MOD_PATH=$(TARGET_DIR) \
		modules_install
	make depmod
#	mkdir -p ${TARGET_DIR}/etc/modules-load.d
#	echo mali > ${TARGET_DIR}/etc/modules-load.d/mali.conf
	$(REMOVE)/$(HD61_MALI_MODULE)
	$(TOUCH)
