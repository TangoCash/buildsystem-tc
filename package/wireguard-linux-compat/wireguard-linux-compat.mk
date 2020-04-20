#
# wireguard-linux-compat
#
WIREGUARD_LINUX_COMPAT_VER    = 1.0.20200413
WIREGUARD_LINUX_COMPAT_DIR    = wireguard-linux-compat-$(WIREGUARD_LINUX_COMPAT_VER)
WIREGUARD_LINUX_COMPAT_SOURCE = wireguard-linux-compat-$(WIREGUARD_LINUX_COMPAT_VER).tar.xz
WIREGUARD_LINUX_COMPAT_URL    = https://git.zx2c4.com/wireguard-linux-compat/snapshot

$(ARCHIVE)/$(WIREGUARD_LINUX_COMPAT_SOURCE):
	$(DOWNLOAD) $(WIREGUARD_LINUX_COMPAT_URL)/$(WIREGUARD_LINUX_COMPAT_SOURCE)

WIREGUARD_LINUX_COMPAT_PATCH = \
	wireguard-linux-compat.patch

$(D)/wireguard-linux-compat: bootstrap kernel libmnl $(ARCHIVE)/$(WIREGUARD_LINUX_COMPAT_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(WIREGUARD_LINUX_COMPAT_DIR)
	$(UNTAR)/$(WIREGUARD_LINUX_COMPAT_SOURCE)
	$(CHDIR)/$(WIREGUARD_LINUX_COMPAT_DIR)/src; \
		$(call apply_patches, $(WIREGUARD_LINUX_COMPAT_PATCH)); \
		$(BUILD_ENV) \
		$(MAKE) all     $(KERNEL_MAKEVARS); \
		$(MAKE) install $(KERNEL_MAKEVARS) INSTALL_MOD_PATH=$(TARGET_DIR)
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in wireguard; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/wireguard.conf; \
	done
	make depmod
	$(REMOVE)/$(WIREGUARD_LINUX_COMPAT_DIR)
	$(TOUCH)
