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
	0001-libmad-pc.patch \
	0002-libmad-frame_length.patch \
	0003-libmad-mips-h-constraint-removal.patch \
	0004-libmad-remove-deprecated-cflags.patch \
	0005-libmad-thumb2-fixed-arm.patch \
	0006-libmad-thumb2-imdct-arm.patch

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
			$(if $(filter $(TARGET_ARCH), arm mips),--enable-fpm=$(TARGET_ARCH),) \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libmad.la
	$(REMOVE)/$(LIBMAD_DIR)
	$(TOUCH)
