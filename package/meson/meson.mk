#
# host-meson
#
HOST_MESON_VER    = 0.54.2
HOST_MESON_DIR    = meson-$(HOST_MESON_VER)
HOST_MESON_SOURCE = meson-$(HOST_MESON_VER).tar.gz
HOST_MESON_URL    = https://github.com/mesonbuild/meson/releases/download/$(HOST_MESON_VER)

HOST_MESON_TARGET_CPU_FAMILY = $(BOXARCH)

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
	$(REMOVE)/$(HOST_MESON_DIR)
	$(TOUCH)
