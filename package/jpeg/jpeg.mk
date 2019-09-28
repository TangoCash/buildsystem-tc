#
# jpeg
#
JPEG_VER    = 8d
JPEG_DIR    = jpeg-$(JPEG_VER)
JPEG_SOURCE = jpegsrc.v$(JPEG_VER).tar.gz
JPEG_URL    = http://www.ijg.org/files

$(ARCHIVE)/$(JPEG_SOURCE):
	$(DOWNLOAD) $(JPEG_URL)/$(JPEG_SOURCE)

JPEG_PATCH  = \
	jpeg.patch

$(D)/jpeg: bootstrap $(ARCHIVE)/$(JPEG_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(JPEG_DIR)
	$(UNTAR)/$(JPEG_SOURCE)
	$(CHDIR)/$(JPEG_DIR); \
		$(call apply_patches, $(JPEG_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libjpeg.la
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,cjpeg djpeg jpegtran rdjpgcom wrjpgcom)
	$(REMOVE)/$(JPEG_DIR)
	$(TOUCH)
