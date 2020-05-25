#
# libdpf
#
LIBDPF_VER    = git
LIBDPF_DIR    = dpf-ax.$(LIBDPF_VER)
LIBDPF_SOURCE = dpf-ax.$(LIBDPF_VER)
LIBDPF_URL    = $(MAX-GIT-GITHUB)

LIBDPF_PATCH  = \
	0001-crossbuild.patch

$(D)/libdpf: bootstrap libusb-compat
	$(START_BUILD)
	$(REMOVE)/$(LIBDPF_DIR)
	$(GET-GIT-SOURCE) $(LIBDPF_URL)/$(LIBDPF_SOURCE) $(ARCHIVE)/$(LIBDPF_SOURCE)
	$(CPDIR)/$(LIBDPF_DIR)
	$(CHDIR)/$(LIBDPF_DIR)/dpflib; \
		$(call apply_patches, $(LIBDPF_PATCH)); \
		make libdpf.a CC=$(TARGET_CC) PREFIX=$(TARGET_DIR)/usr; \
		mkdir -p $(TARGET_INCLUDE_DIR)/libdpf; \
		cp dpf.h $(TARGET_INCLUDE_DIR)/libdpf/libdpf.h; \
		cp ../include/spiflash.h $(TARGET_INCLUDE_DIR)/libdpf/; \
		cp ../include/usbuser.h $(TARGET_INCLUDE_DIR)/libdpf/; \
		cp libdpf.a $(TARGET_LIB_DIR)/
	$(REMOVE)/$(LIBDPF_DIR)
	$(TOUCH)
