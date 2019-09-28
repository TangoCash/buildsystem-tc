#
# wget
#
WGET_VER    = 1.20.3
WGET_DIR    = wget-$(WGET_VER)
WGET_SOURCE = wget-$(WGET_VER).tar.gz
WGET_URL    = https://ftp.gnu.org/gnu/wget

$(ARCHIVE)/$(WGET_SOURCE):
	$(DOWNLOAD) $(WGET_URL)/$(WGET_SOURCE)

WGET_PATCH  = \
	wget-improve-reproducibility.patch \
	wget-Strip-long-version-output.patch

$(D)/wget: bootstrap openssl $(ARCHIVE)/$(WGET_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(WGET_DIR)
	$(UNTAR)/$(WGET_SOURCE)
	$(CHDIR)/$(WGET_DIR); \
		$(call apply_patches, $(WGET_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--infodir=/.remove \
			--with-openssl \
			--with-ssl=openssl \
			--with-libssl-prefix=$(TARGET_DIR) \
			--disable-ipv6 \
			--disable-debug \
			--disable-nls \
			--disable-opie \
			--disable-digest \
			--disable-rpath \
			--disable-iri \
			--disable-pcre \
			--without-libpsl \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(WGET_DIR)
	$(TOUCH)
