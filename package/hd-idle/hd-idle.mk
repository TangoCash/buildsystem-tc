#
# hd-idle
#
HD_IDLE_VER    = 1.05
HD_IDLE_DIR    = hd-idle
HD_IDLE_SOURCE = hd-idle-$(HD_IDLE_VER).tgz
HD_IDLE_URL    = https://sourceforge.net/projects/hd-idle/files

$(ARCHIVE)/$(HD_IDLE_SOURCE):
	$(DOWNLOAD) $(HD_IDLE_URL)/$(HD_IDLE_SOURCE)

HD_IDLE_PATCH  = \
	hd-idle.patch

$(D)/hd-idle: bootstrap $(ARCHIVE)/$(HD_IDLE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HD_IDLE_DIR)
	$(UNTAR)/$(HD_IDLE_SOURCE)
	$(CHDIR)/$(HD_IDLE_DIR); \
		$(call apply_patches, $(HD_IDLE_PATCH)); \
		$(BUILD_ENV) \
		$(MAKE) CC=$(TARGET_CC); \
		$(MAKE) install TARGET_DIR=$(TARGET_DIR) install
	$(REMOVE)/$(HD_IDLE_DIR)
	$(TOUCH)
