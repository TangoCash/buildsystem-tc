#
# libcap
#
LIBCAP_VER    = 2.25
LIBCAP_DIR    = libcap-$(LIBCAP_VER)
LIBCAP_SOURCE = libcap-$(LIBCAP_VER).tar.xz
LIBCAP_URL    = https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2

$(ARCHIVE)/$(LIBCAP_SOURCE):
	$(DOWNLOAD) $(LIBCAP_URL)/$(LIBCAP_SOURCE)

LIBCAP_PATCH  = \
	0001-build-system-fixes-for-cross-compilation.patch \
	0002-libcap-split-install-into-install-shared-install-sta.patch \
	0003-libcap-cap_file.c-fix-build-with-old-kernel-headers.patch

LIBCAP_MAKE_FLAGS = \
	BUILD_CC="$(HOSTCC)" \
	BUILD_CFLAGS="$(HOST_CFLAGS)"

$(D)/libcap: bootstrap $(ARCHIVE)/$(LIBCAP_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBCAP_DIR)
	$(UNTAR)/$(LIBCAP_SOURCE)
	$(CHDIR)/$(LIBCAP_DIR); \
		$(call apply_patches, $(LIBCAP_PATCH)); \
		sed 's@^BUILD_GPERF@#\0@' -i Make.Rules; \
		$(BUILD_ENV) $(MAKE) -C libcap $(LIBCAP_MAKE_FLAGS); \
		$(BUILD_ENV) $(MAKE) -C libcap $(LIBCAP_MAKE_FLAGS) DESTDIR=$(TARGET_DIR) prefix=/usr lib=lib install
	$(REMOVE)/$(LIBCAP_DIR)
	$(TOUCH)
