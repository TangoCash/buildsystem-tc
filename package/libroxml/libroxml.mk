#
# libroxml
#
LIBROXML_VER    = 2.3.0
LIBROXML_DIR    = libroxml-$(LIBROXML_VER)
LIBROXML_SOURCE = libroxml-$(LIBROXML_VER).tar.gz
LIBROXML_URL    = http://download.libroxml.net/pool/v2.x

$(ARCHIVE)/$(LIBROXML_SOURCE):
	$(DOWNLOAD) $(LIBROXML_URL)/$(LIBROXML_SOURCE)

$(D)/libroxml: bootstrap $(ARCHIVE)/$(LIBROXML_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBROXML_DIR)
	$(UNTAR)/$(LIBROXML_SOURCE)
	$(CHDIR)/$(LIBROXML_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--enable-shared \
			--disable-static \
			--disable-roxml \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libroxml.la
	$(REMOVE)/$(LIBROXML_DIR)
	$(TOUCH)
