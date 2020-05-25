#
# dosfstools
#
DOSFSTOOLS_VER    = 4.1
DOSFSTOOLS_DIR    = dosfstools-$(DOSFSTOOLS_VER)
DOSFSTOOLS_SOURCE = dosfstools-$(DOSFSTOOLS_VER).tar.xz
DOSFSTOOLS_URL    = https://github.com/dosfstools/dosfstools/releases/download/v$(DOSFSTOOLS_VER)

$(ARCHIVE)/$(DOSFSTOOLS_SOURCE):
	$(DOWNLOAD) $(DOSFSTOOLS_URL)/$(DOSFSTOOLS_SOURCE)

DOSFSTOOLS_PATCH  = \
	0001-switch-to-AC_CHECK_LIB-for-iconv-library-linking.patch

DOSFSTOOLS_CFLAGS = $(TARGET_CFLAGS) -D_GNU_SOURCE -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64 -fomit-frame-pointer

$(D)/dosfstools: bootstrap libiconv $(ARCHIVE)/$(DOSFSTOOLS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(DOSFSTOOLS_DIR)
	$(UNTAR)/$(DOSFSTOOLS_SOURCE)
	$(CHDIR)/$(DOSFSTOOLS_DIR); \
		$(call apply_patches, $(DOSFSTOOLS_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix= \
			--mandir=/.remove \
			--docdir=/.remove \
			--without-udev \
			--enable-compat-symlinks \
			CFLAGS="$(DOSFSTOOLS_CFLAGS)" \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(DOSFSTOOLS_DIR)
	$(TOUCH)
