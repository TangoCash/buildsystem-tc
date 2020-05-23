#
# host-meson
#
HOST_MESON_VER    = 0.54.2
HOST_MESON_DIR    = meson-$(HOST_MESON_VER)
HOST_MESON_SOURCE = meson-$(HOST_MESON_VER).tar.gz
HOST_MESON_URL    = https://github.com/mesonbuild/meson/releases/download/$(HOST_MESON_VER)

$(ARCHIVE)/$(HOST_MESON_SOURCE):
	$(DOWNLOAD) $(HOST_MESON_URL)/$(HOST_MESON_SOURCE)

HOST_MESON_PATCH  = \
	0001-Only-fix-RPATH-if-install_rpath-is-not-empty.patch \
	0002-Prefer-ext-static-libs-when-default-library-static.patch \
	0003-Allow-overriding-g-ir-scanner-and-g-ir-compiler-bina.patch \
	0004-mesonbuild-dependencies-base.py-add-pkg_config_stati.patch

$(D)/host-meson: bootstrap host-ninja host-python3 python3-setuptools $(ARCHIVE)/$(HOST_MESON_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HOST_MESON_DIR)
	$(UNTAR)/$(HOST_MESON_SOURCE)
	$(CHDIR)/$(HOST_MESON_DIR); \
		$(HOST_PYTHON_BUILD); \
		$(HOST_PYTHON_INSTALL)
	$(call CROSS_COMPILATION_CONFIG,"$(HOST_DIR)/bin")
	$(REMOVE)/$(HOST_MESON_DIR)
	$(TOUCH)

define CROSS_COMPILATION_CONFIG
	echo "[binaries]" > $(1)/cross-compilation.conf
	echo "c = '$(TARGET_CC)'" >> $(1)/cross-compilation.conf
	echo "cpp = '$(TARGET_CPP)'" >> $(1)/cross-compilation.conf
	echo "ar = '$(TARGET_AR)'" >> $(1)/cross-compilation.conf
	echo "strip = '$(TARGET_STRIP)'" >> $(1)/cross-compilation.conf
	echo "pkgconfig = '$(HOST_DIR)/bin/$(TARGET)-pkg-config'" >> $(1)/cross-compilation.conf
	echo "" >> $(1)/cross-compilation.conf
	echo "[properties]" >> $(1)/cross-compilation.conf
	echo "c_args = ['-I$(TARGET_INCLUDE_DIR)']" >> $(1)/cross-compilation.conf
	echo "c_link_args = ['-Wl,-O1 -L$(TARGET_LIB_DIR)']" >> $(1)/cross-compilation.conf
	echo "cpp_args = ['-I$(TARGET_INCLUDE_DIR)']" >> $(1)/cross-compilation.conf
	echo "cpp_link_args = ['-Wl,-O1 -L$(TARGET_LIB_DIR)']" >> $(1)/cross-compilation.conf
	echo "" >> $(1)/cross-compilation.conf
	echo "[host_machine]" >> $(1)/cross-compilation.conf
	echo "system = 'linux'" >> $(1)/cross-compilation.conf
	echo "cpu_family = '$(TARGET_ARCH)'" >> $(1)/cross-compilation.conf
#	echo "cpu = 'cortex-a15'" >> $(1)/cross-compilation.conf
	echo "endian = '$(TARGET_ENDIAN)'" >> $(1)/cross-compilation.conf
endef
