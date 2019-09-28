#
# libjpeg-turbo
#
LIBJPEG_TURBO_VER    = 2.0.2
LIBJPEG_TURBO_DIR    = libjpeg-turbo-$(LIBJPEG_TURBO_VER)
LIBJPEG_TURBO_SOURCE = libjpeg-turbo-$(LIBJPEG_TURBO_VER).tar.gz
LIBJPEG_TURBO_URL    = https://sourceforge.net/projects/libjpeg-turbo/files/$(LIBJPEG_TURBO_VER)

$(ARCHIVE)/$(LIBJPEG_TURBO_SOURCE):
	$(DOWNLOAD) $(LIBJPEG_TURBO_URL)/$(LIBJPEG_TURBO_SOURCE)

LIBJPEG_TURBO_PATCH  = \
	tiff-ojpeg.patch

$(D)/libjpeg-turbo: bootstrap $(ARCHIVE)/$(LIBJPEG_TURBO_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBJPEG_TURBO_DIR)
	$(UNTAR)/$(LIBJPEG_TURBO_SOURCE)
	$(CHDIR)/$(LIBJPEG_TURBO_DIR); \
		$(call apply_patches, $(LIBJPEG_TURBO_PATCH)); \
		$(CMAKE) \
			-DWITH_SIMD=False \
			-DWITH_JPEG8=80 \
			| tail -n +90 \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,cjpeg djpeg jpegtran rdjpgcom tjbench wrjpgcom)
	$(REMOVE)/$(LIBJPEG_TURBO_DIR)
	$(TOUCH)
