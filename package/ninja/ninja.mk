#
# host-ninja
#
HOST_NINJA_VER    = 1.10.0
HOST_NINJA_DIR    = ninja-$(HOST_NINJA_VER)
HOST_NINJA_SOURCE = ninja.tar.gz
HOST_NINJA_URL    = https://github.com/ninja-build/ninja/archive

$(ARCHIVE)/$(HOST_NINJA_SOURCE):
	$(DOWNLOAD) $(HOST_NINJA_URL)/v$(HOST_NINJA_VER).tar.gz -O $@

HOST_NINJA_PATCH = \
	0001-set-minimum-cmake-version-to-3.10.patch \
	0002-remove-fdiagnostics-color-from-make-command.patch \
	0003-CMake-fix-object-library-usage.patch

$(D)/host-ninja: bootstrap $(ARCHIVE)/$(HOST_NINJA_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HOST_NINJA_DIR)
	$(UNTAR)/$(HOST_NINJA_SOURCE)
	$(CHDIR)/$(HOST_NINJA_DIR); \
		$(call apply_patches, $(HOST_NINJA_PATCH)); \
		cmake . \
			-DCMAKE_INSTALL_PREFIX="" \
		; \
		$(MAKE)
		$(INSTALL_EXEC) -D $(BUILD_DIR)/$(HOST_NINJA_DIR)/ninja $(HOST_DIR)/bin/ninja
	$(REMOVE)/$(HOST_NINJA_DIR)
	$(TOUCH)
