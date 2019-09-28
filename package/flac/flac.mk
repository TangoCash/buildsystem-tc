#
# flac
#
FLAC_VER    = 1.3.3
FLAC_DIR    = flac-$(FLAC_VER)
FLAC_SOURCE = flac-$(FLAC_VER).tar.xz
FLAC_URL    = https://ftp.osuosl.org/pub/xiph/releases/flac

$(ARCHIVE)/$(FLAC_SOURCE):
	$(DOWNLOAD) $(FLAC_URL)/$(FLAC_SOURCE)

FLAC_PATCH  = \
	001-no-docs-and-examples.patch \
	002-no-utility.patch \
	010-utime.patch

$(D)/flac: bootstrap $(ARCHIVE)/$(FLAC_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(FLAC_DIR)
	$(UNTAR)/$(FLAC_SOURCE)
	$(CHDIR)/$(FLAC_DIR); \
		$(call apply_patches, $(FLAC_PATCH)); \
		touch NEWS AUTHORS ChangeLog; \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--datarootdir=/.remove \
			--disable-cpplibs \
			--disable-debug \
			--disable-asm-optimizations \
			--disable-sse \
			--disable-altivec \
			--disable-doxygen-docs \
			--disable-thorough-tests \
			--disable-exhaustive-tests \
			--disable-valgrind-testing \
			--disable-ogg \
			--disable-oggtest \
			--disable-local-xmms-plugin \
			--disable-xmms-plugin \
			--disable-examples \
			--disable-rpath \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR) docdir=/.remove
	$(REWRITE_LIBTOOL)/libFLAC.la
	$(REMOVE)/$(FLAC_DIR)
	$(TOUCH)
