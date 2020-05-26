#
# libmad
#
LIBMAD_VER    = 0.15.1b
LIBMAD_DIR    = libmad-$(LIBMAD_VER)
LIBMAD_SOURCE = libmad-$(LIBMAD_VER).tar.gz
LIBMAD_URL    = https://sourceforge.net/projects/mad/files/libmad/$(LIBMAD_VER)

$(ARCHIVE)/$(LIBMAD_SOURCE):
	$(DOWNLOAD) $(LIBMAD_URL)/$(LIBMAD_SOURCE)

LIBMAD_PATCH  = \
	libmad-pc.patch \
	libmad-frame_length.patch \
	libmad-mips-h-constraint-removal.patch \
	libmad-remove-deprecated-cflags.patch \
	libmad-thumb2-fixed-arm.patch \
	libmad-thumb2-imdct-arm.patch \
	libmad-add-pkgconfig.patch

$(D)/libmad: bootstrap $(ARCHIVE)/$(LIBMAD_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBMAD_DIR)
	$(UNTAR)/$(LIBMAD_SOURCE)
	$(CHDIR)/$(LIBMAD_DIR); \
		$(call apply_patches, $(LIBMAD_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--enable-shared=yes \
			--enable-accuracy \
			--enable-sso \
			--disable-debugging \
			 \
			$(if $(filter $(BOXARCH), arm mips),--enable-fpm=$(BOXARCH),--enable-fpm=64bit) \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libmad.la
	$(REMOVE)/$(LIBMAD_DIR)
	$(TOUCH)
