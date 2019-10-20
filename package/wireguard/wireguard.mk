#
# wireguard
#
WIREGUARD_VER    = 0.0.20191012
WIREGUARD_DIR    = WireGuard-$(WIREGUARD_VER)
WIREGUARD_SOURCE = WireGuard-$(WIREGUARD_VER).tar.xz
WIREGUARD_URL    = https://git.zx2c4.com/WireGuard/snapshot

$(ARCHIVE)/$(WIREGUARD_SOURCE):
	$(DOWNLOAD) $(WIREGUARD_URL)/$(WIREGUARD_SOURCE)

WIREGUARD_PATCH = \
	wireguard.patch

WIREGUARD_MAKE_OPTS = WITH_SYSTEMDUNITS=no WITH_BASHCOMPLETION=yes WITH_WGQUICK=yes

$(D)/wireguard: bootstrap kernel libmnl $(ARCHIVE)/$(WIREGUARD_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(WIREGUARD_DIR)
	$(UNTAR)/$(WIREGUARD_SOURCE)
	$(CHDIR)/$(WIREGUARD_DIR)/src; \
		$(call apply_patches, $(WIREGUARD_PATCH)); \
		$(BUILD_ENV) \
		$(MAKE) all     $(KERNEL_MAKEVARS) $(WIREGUARD_MAKE_OPTS) PREFIX=/usr; \
		$(MAKE) install $(KERNEL_MAKEVARS) $(WIREGUARD_MAKE_OPTS) INSTALL_MOD_PATH=$(TARGET_DIR) DESTDIR=$(TARGET_DIR) MANDIR=/.remove
	mkdir -p ${TARGET_DIR}/etc/modules-load.d
	for i in wireguard; do \
		echo $$i >> ${TARGET_DIR}/etc/modules-load.d/wireguard.conf; \
	done
	make depmod
	$(REMOVE)/$(WIREGUARD_DIR)
	$(TOUCH)
