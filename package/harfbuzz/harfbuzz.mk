#
# harfbuzz
#
HARFBUZZ_VER    = 1.8.8
HARFBUZZ_DIR    = harfbuzz-$(HARFBUZZ_VER)
HARFBUZZ_SOURCE = harfbuzz-$(HARFBUZZ_VER).tar.bz2
HARFBUZZ_URL    = https://www.freedesktop.org/software/harfbuzz/release

$(ARCHIVE)/$(HARFBUZZ_SOURCE):
	$(DOWNLOAD) $(HARFBUZZ_URL)/$(HARFBUZZ_SOURCE)

HARFBUZZ_PATCH  = \
	disable-docs.patch

$(D)/harfbuzz: bootstrap fontconfig glib2 cairo freetype $(ARCHIVE)/$(HARFBUZZ_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HARFBUZZ_DIR)
	$(UNTAR)/$(HARFBUZZ_SOURCE)
	$(CHDIR)/$(HARFBUZZ_DIR); \
		$(call apply_patches, $(HARFBUZZ_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--with-cairo \
			--with-fontconfig \
			--with-freetype \
			--with-glib \
			--without-graphite2 \
			--without-icu \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libharfbuzz.la
	$(REWRITE_LIBTOOL)/libharfbuzz-subset.la
	$(REMOVE)/$(HARFBUZZ_DIR)
	$(TOUCH)
