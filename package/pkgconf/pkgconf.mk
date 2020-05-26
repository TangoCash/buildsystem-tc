#
# host-pkgconf
#
HOST_PKGCONF_VER    = 1.6.3
HOST_PKGCONF_DIR    = pkgconf-$(HOST_PKGCONF_VER)
HOST_PKGCONF_SOURCE = pkgconf-$(HOST_PKGCONF_VER).tar.xz
HOST_PKGCONF_URL    = https://distfiles.dereferenced.org/pkgconf

$(ARCHIVE)/$(HOST_PKGCONF_SOURCE):
	$(DOWNLOAD) $(HOST_PKGCONF_URL)/$(HOST_PKGCONF_SOURCE)

HOST_PKGCONF_PATCH  = \
	0001-Only-prefix-with-the-sysroot-a-subset-of-variables.patch \
	0002-Revert-main-assume-modversion-insted-of-version-if-o.patch

$(D)/host-pkgconf: directories $(ARCHIVE)/$(HOST_PKGCONF_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HOST_PKGCONF_DIR)
	$(UNTAR)/$(HOST_PKGCONF_SOURCE)
	$(CHDIR)/$(HOST_PKGCONF_DIR); \
		$(call apply_patches, $(HOST_PKGCONF_PATCH)); \
		./configure $(SILENT_OPT) \
			--prefix=$(HOST_DIR) \
			; \
		$(MAKE); \
		$(MAKE) install
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/pkgconf-pkg-config $(HOST_DIR)/bin/pkg-config
	ln -sf pkg-config $(HOST_DIR)/bin/$(TARGET)-pkg-config
	$(REMOVE)/$(HOST_PKGCONF_DIR)
	$(TOUCH)
