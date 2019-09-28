#
# libusb
#
LIBUSB_VER    = 1.0.23
LIBUSB_DIR    = libusb-$(LIBUSB_VER)
LIBUSB_SOURCE = libusb-$(LIBUSB_VER).tar.bz2
LIBUSB_URL    = https://github.com/libusb/libusb/releases/download/v$(LIBUSB_VER)

$(ARCHIVE)/$(LIBUSB_SOURCE):
	$(DOWNLOAD) $(LIBUSB_URL)/$(LIBUSB_SOURCE)

LIBUSB_PATCH  = \
	libusb.patch

$(D)/libusb: bootstrap $(ARCHIVE)/$(LIBUSB_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBUSB_DIR)
	$(UNTAR)/$(LIBUSB_SOURCE)
	$(CHDIR)/$(LIBUSB_DIR); \
		$(call apply_patches, $(LIBUSB_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			--enable-static \
			--disable-log \
			--disable-debug-log \
			--disable-udev \
			--disable-examples-build \
			; \
		$(MAKE) ; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libusb-1.0.la
	$(REMOVE)/$(LIBUSB_DIR)
	$(TOUCH)
