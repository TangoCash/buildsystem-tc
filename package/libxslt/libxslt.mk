#
# libxslt
#
LIBXSLT_VER    = 1.1.34
LIBXSLT_DIR    = libxslt-$(LIBXSLT_VER)
LIBXSLT_SOURCE = libxslt-$(LIBXSLT_VER).tar.gz
LIBXSLT_URL    = ftp://xmlsoft.org/libxml2

$(ARCHIVE)/$(LIBXSLT_SOURCE):
	$(DOWNLOAD) $(LIBXSLT_URL)/$(LIBXSLT_SOURCE)

$(D)/libxslt: bootstrap libxml2 $(ARCHIVE)/$(LIBXSLT_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBXSLT_DIR)
	$(UNTAR)/$(LIBXSLT_SOURCE)
	$(CHDIR)/$(LIBXSLT_DIR); \
		$(CONFIGURE) \
			CPPFLAGS="$(CPPFLAGS) -I$(TARGET_INCLUDE_DIR)/libxml2" \
			--prefix=/usr \
			--datarootdir=/.remove \
			--enable-shared \
			--disable-static \
			--without-python \
			--without-crypto \
			--without-debug \
			--without-mem-debug \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	mv $(TARGET_DIR)/usr/bin/xslt-config $(HOST_DIR)/bin
	$(REWRITE_CONFIG) $(HOST_DIR)/bin/xslt-config
	$(REWRITE_LIBTOOL)/libexslt.la
	$(REWRITE_LIBTOOL)/libxslt.la
	rm -rf $(TARGETLIB)/xsltConf.sh
	rm -rf $(TARGETLIB)/libxslt-plugins/
	$(REMOVE)/$(LIBXSLT_DIR)
	$(TOUCH)
