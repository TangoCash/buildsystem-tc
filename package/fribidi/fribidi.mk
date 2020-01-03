#
# fribidi
#
FRIBIDI_VER    = 1.0.8
FRIBIDI_DIR    = fribidi-$(FRIBIDI_VER)
FRIBIDI_SOURCE = fribidi-$(FRIBIDI_VER).tar.bz2
FRIBIDI_URL    = https://github.com/fribidi/fribidi/releases/download/v$(FRIBIDI_VER)

$(ARCHIVE)/$(FRIBIDI_SOURCE):
	$(DOWNLOAD) $(FRIBIDI_URL)/$(FRIBIDI_SOURCE)

FRIBIDI_PATCH  = \
	fribidi.patch

$(D)/fribidi: bootstrap $(ARCHIVE)/$(FRIBIDI_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(FRIBIDI_DIR)
	$(UNTAR)/$(FRIBIDI_SOURCE)
	$(CHDIR)/$(FRIBIDI_DIR); \
		$(call apply_patches, $(FRIBIDI_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--enable-shared \
			--enable-static \
			--disable-debug \
			--disable-deprecated \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libfribidi.la
	cd $(TARGET_DIR) && rm usr/bin/fribidi
	$(REMOVE)/$(FRIBIDI_DIR)
	$(TOUCH)
