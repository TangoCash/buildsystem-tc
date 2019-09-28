#
# parted
#
PARTED_VER    = 3.2
PARTED_DIR    = parted-$(PARTED_VER)
PARTED_SOURCE = parted-$(PARTED_VER).tar.xz
PARTED_URL    = https://ftp.gnu.org/gnu/parted

$(ARCHIVE)/$(PARTED_SOURCE):
	$(DOWNLOAD) $(PARTED_URL)/$(PARTED_SOURCE)

PARTED_PATCH  = \
	device-mapper.patch \
	iconv.patch \
	fix-compile-in-old-ubuntu.patch \
	linux-Include-sys-sysmacros.h-for-major-macro.patch

$(D)/parted: bootstrap e2fsprogs libiconv $(ARCHIVE)/$(PARTED_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(PARTED_DIR)
	$(UNTAR)/$(PARTED_SOURCE)
	$(CHDIR)/$(PARTED_DIR); \
		$(call apply_patches, $(PARTED_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--target=$(TARGET) \
			--prefix=/usr \
			--mandir=/.remove \
			--infodir=/.remove \
			--without-readline \
			--enable-shared \
			--disable-static \
			--disable-dynamic-loading \
			--disable-debug \
			--disable-device-mapper \
			--disable-nls \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libparted.la
	$(REWRITE_LIBTOOL)/libparted-fs-resize.la
	$(REMOVE)/$(PARTED_DIR)
	$(TOUCH)
