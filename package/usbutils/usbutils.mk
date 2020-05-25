#
# usbutils
#
USBUTILS_VER    = 007
USBUTILS_DIR    = usbutils-$(USBUTILS_VER)
USBUTILS_SOURCE = usbutils-$(USBUTILS_VER).tar.xz
USBUTILS_URL    = https://www.kernel.org/pub/linux/utils/usb/usbutils

$(ARCHIVE)/$(USBUTILS_SOURCE):
	$(DOWNLOAD) $(USBUTILS_URL)/$(USBUTILS_SOURCE)

USBUTILS_PATCH  = \
	0001-avoid-dependency-on-bash.patch \
	0002-fix-null-pointer-crash.patch \
	0003-fix-build.patch \
	0004-iconv.patch

$(D)/usbutils: libusb $(ARCHIVE)/$(USBUTILS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(USBUTILS_DIR)
	$(UNTAR)/$(USBUTILS_SOURCE)
	$(CHDIR)/$(USBUTILS_DIR); \
		$(call apply_patches, $(USBUTILS_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--target=$(TARGET) \
			--prefix=/usr \
			--mandir=/.remove \
			--datadir=/usr/share/hwdata \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	rm -rf $(addprefix $(TARGET_DIR)/usr/bin/,lsusb.py usbhid-dump)
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/,pkgconfig)
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/hwdata/,usb.ids.gz)
	$(REMOVE)/$(USBUTILS_DIR)
	$(TOUCH)
