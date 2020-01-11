#
# libcurl
#
LIBCURL_VER    = 7.68.0
LIBCURL_DIR    = curl-$(LIBCURL_VER)
LIBCURL_SOURCE = curl-$(LIBCURL_VER).tar.bz2
LIBCURL_URL    = https://curl.haxx.se/download

$(ARCHIVE)/$(LIBCURL_SOURCE):
	$(DOWNLOAD) $(LIBCURL_URL)/$(LIBCURL_SOURCE)

LIBCURL_PATCH  = \
	no_docs_tests.patch

$(D)/libcurl: bootstrap zlib openssl ca-bundle $(ARCHIVE)/$(LIBCURL_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBCURL_DIR)
	$(UNTAR)/$(LIBCURL_SOURCE)
	$(CHDIR)/$(LIBCURL_DIR); \
		$(call apply_patches, $(LIBCURL_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--enable-silent-rules \
			--disable-debug \
			--disable-curldebug \
			--disable-manual \
			--disable-file \
			--disable-rtsp \
			--disable-dict \
			--disable-imap \
			--disable-pop3 \
			--disable-smtp \
			--enable-shared \
			--enable-optimize \
			--disable-verbose \
			--disable-ldap \
			--without-libidn \
			--without-libidn2 \
			--without-winidn \
			--without-libpsl \
			--with-ca-bundle=$(CA_BUNDLE_DIR)/$(CA_BUNDLE) \
			--with-random=/dev/urandom \
			--with-ssl=$(TARGET_DIR)/usr \
			; \
		$(MAKE) all; \
		sed -e "s,^prefix=,prefix=$(TARGET_DIR)," < curl-config > $(HOST_DIR)/bin/curl-config; \
		chmod 755 $(HOST_DIR)/bin/curl-config; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
		rm -f $(TARGET_DIR)/usr/bin/curl-config
	$(REWRITE_LIBTOOL)/libcurl.la
	$(REMOVE)/$(LIBCURL_DIR)
	$(TOUCH)
