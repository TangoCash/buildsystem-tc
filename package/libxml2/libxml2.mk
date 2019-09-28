#
# libxml2
#
LIBXML2_VER    = 2.9.9
LIBXML2_DIR    = libxml2-$(LIBXML2_VER)
LIBXML2_SOURCE = libxml2-$(LIBXML2_VER).tar.gz
LIBXML2_URL    = http://xmlsoft.org/sources

$(ARCHIVE)/$(LIBXML2_SOURCE):
	$(DOWNLOAD) $(LIBXML2_URL)/$(LIBXML2_SOURCE)

LIBXML2_PATCH  = \
	libxml2.patch \
	no_docs_examples_tests.patch

$(D)/libxml2: bootstrap zlib $(ARCHIVE)/$(LIBXML2_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBXML2_DIR)
	$(UNTAR)/$(LIBXML2_SOURCE)
	$(CHDIR)/$(LIBXML2_DIR); \
		$(call apply_patches, $(LIBXML2_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--target=$(TARGET) \
			--prefix=/usr \
			--datarootdir=/.remove \
			--enable-shared \
			--disable-static \
			--without-python \
			--without-catalog \
			--without-debug \
			--without-legacy \
			--without-docbook \
			--without-mem-debug \
			--without-lzma \
			--with-zlib \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR); \
		if [ -d $(TARGET_INCLUDE_DIR)/libxml2/libxml ] ; then \
			ln -sf ./libxml2/libxml $(TARGET_INCLUDE_DIR)/libxml; \
		fi;
	mv $(TARGET_DIR)/usr/bin/xml2-config $(HOST_DIR)/bin
	$(REWRITE_CONFIG) $(HOST_DIR)/bin/xml2-config
	$(REWRITE_LIBTOOL)/libxml2.la
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,xmlcatalog xmllint)
	rm -rf $(TARGET_LIB_DIR)/xml2Conf.sh
	rm -rf $(TARGET_LIB_DIR)/cmake
	$(REMOVE)/$(LIBXML2_DIR)
	$(TOUCH)
