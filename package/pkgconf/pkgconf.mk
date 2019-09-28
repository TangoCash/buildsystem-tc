#
# pkgconf
#
PKGCONF_VER    = 1.6.3
PKGCONF_DIR    = pkgconf-$(PKGCONF_VER)
PKGCONF_SOURCE = pkgconf-$(PKGCONF_VER).tar.xz
PKGCONF_URL    = https://distfiles.dereferenced.org/pkgconf

$(ARCHIVE)/$(PKGCONF_SOURCE):
	$(DOWNLOAD) $(PKGCONF_URL)/$(PKGCONF_SOURCE)

PKGCONF_PATCH  = \
	0001-Only-prefix-with-the-sysroot-a-subset-of-variables.patch \
	0002-Revert-main-assume-modversion-insted-of-version-if-o.patch

$(D)/pkgconf: directories $(ARCHIVE)/$(PKGCONF_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(PKGCONF_DIR)
	$(UNTAR)/$(PKGCONF_SOURCE)
	$(CHDIR)/$(PKGCONF_DIR); \
		$(call apply_patches, $(PKGCONF_PATCH)); \
		./configure $(SILENT_OPT) \
			--prefix=$(HOST_DIR) \
			; \
		$(MAKE); \
		$(MAKE) install
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/pkgconf-pkg-config $(HOST_DIR)/bin/pkg-config
	ln -sf pkg-config $(HOST_DIR)/bin/$(TARGET)-pkg-config
	$(REMOVE)/$(PKGCONF_DIR)
	$(TOUCH)
