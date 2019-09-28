#
# hd60-mali-module
#
HD60_MALI_MODULE_VER    = DX910-SW-99002-r7p0-00rel0
HD60_MALI_MODULE        = $(HD60_MALI_MODULE_VER)
HD60_MALI_MODULE_SOURCE = $(HD60_MALI_MODULE_VER).tgz
HD60_MALI_MODULE_URL    = https://developer.arm.com/-/media/Files/downloads/mali-drivers/kernel/mali-utgard-gpu

$(ARCHIVE)/$(HD60_MALI_MODULE_SOURCE):
	$(DOWNLOAD) $(HD60_MALI_MODULE_URL)/$(HD60_MALI_MODULE_SOURCE)

HD60_MALI_MODULE_PATCH = \
	hi3798mv200-support.patch

HD60_MALI_MODULE_MAKEVARS = \
	M=$(BUILD_DIR)/$(HD60_MALI_MODULE)/driver/src/devicedrv/mali \
	EXTRA_CFLAGS=" \
	-DCONFIG_MALI_DVFS=y \
	-DCONFIG_GPU_AVS_ENABLE=y" \
	CONFIG_MALI_SHARED_INTERRUPTS=y \
	CONFIG_MALI400=m \
	CONFIG_MALI450=y \
	CONFIG_MALI_DVFS=y \
	CONFIG_GPU_AVS_ENABLE=y

$(D)/hd60-mali-module: bootstrap kernel hd60-libgles-header $(ARCHIVE)/$(HD60_MALI_MODULE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HD60_MALI_MODULE)
	$(UNTAR)/$(HD60_MALI_MODULE_SOURCE)
	$(CHDIR)/$(HD60_MALI_MODULE); \
		$(call apply_patches, $(HD60_MALI_MODULE_PATCH)); \
		$(MAKE) -C $(KERNEL_DIR) $(KERNEL_MAKEVARS) \
		$(HD60_MALI_MODULE_MAKEVARS); \
		$(MAKE) -C $(KERNEL_DIR) $(KERNEL_MAKEVARS) \
		M=$(BUILD_DIR)/$(HD60_MALI_MODULE)/driver/src/devicedrv/mali \
		$(HD60_MALI_MODULE_MAKEVARS) \
		INSTALL_MOD_PATH=$(TARGET_DIR) \
		modules_install
	make depmod
#	mkdir -p ${TARGET_DIR}/etc/modules-load.d
#	echo mali > ${TARGET_DIR}/etc/modules-load.d/mali.conf
	$(REMOVE)/$(HD60_MALI_MODULE)
	$(TOUCH)