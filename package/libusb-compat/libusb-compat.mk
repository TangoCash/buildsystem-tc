#
# libusb-compat
#
LIBUSB_COMPAT_VER    = 0.1.7
LIBUSB_COMPAT_DIR    = libusb-compat-$(LIBUSB_COMPAT_VER)
LIBUSB_COMPAT_SOURCE = libusb-compat-$(LIBUSB_COMPAT_VER).tar.bz2
LIBUSB_COMPAT_URL    = https://github.com/libusb/libusb-compat-0.1/releases/download/v$(LIBUSB_COMPAT_VER)

$(ARCHIVE)/$(LIBUSB_COMPAT_SOURCE):
	$(DOWNLOAD) $(LIBUSB_COMPAT_URL)/$(LIBUSB_COMPAT_SOURCE)

$(D)/libusb-compat: bootstrap libusb $(ARCHIVE)/$(LIBUSB_COMPAT_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBUSB_COMPAT_DIR)
	$(UNTAR)/$(LIBUSB_COMPAT_SOURCE)
	$(CHDIR)/$(LIBUSB_COMPAT_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--disable-log \
			--disable-debug-log \
			--disable-examples-build \
			; \
		$(MAKE) ; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	rm -f $(TARGET_DIR)/usr/bin/libusb-config
	$(REWRITE_LIBTOOL)/libusb.la
	$(REMOVE)/$(LIBUSB_COMPAT_DIR)
	$(TOUCH)
