#
# opkg
#
OPKG_VER    = 0.3.3
OPKG_DIR    = opkg-$(OPKG_VER)
OPKG_SOURCE = opkg-$(OPKG_VER).tar.gz
OPKG_URL    = https://git.yoctoproject.org/cgit/cgit.cgi/opkg/snapshot

$(ARCHIVE)/$(OPKG_SOURCE):
	$(DOWNLOAD) $(OPKG_URL)/$(OPKG_SOURCE)

OPKG_PATCH = \
	opkg.patch

$(D)/opkg: bootstrap host-opkg libarchive $(ARCHIVE)/$(OPKG_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(OPKG_DIR)
	$(UNTAR)/$(OPKG_SOURCE)
	$(CHDIR)/$(OPKG_DIR); \
		$(call apply_patches, $(OPKG_PATCH)); \
		LIBARCHIVE_LIBS="-L$(TARGET_DIR)/usr/lib -larchive" \
		LIBARCHIVE_CFLAGS="-I$(TARGET_DIR)/usr/include" \
		$(CONFIGURE) \
			--prefix=/usr \
			--disable-curl \
			--disable-gpg \
			--mandir=/.remove \
			; \
		$(MAKE) all ; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	mkdir -p $(TARGET_DIR)/usr/lib/opkg
	mkdir -p $(TARGET_DIR)/etc/opkg
	ln -sf opkg $(TARGET_DIR)/usr/bin/opkg-cl
	$(REWRITE_LIBTOOL)/libopkg.la
	$(REMOVE)/$(OPKG_DIR)
	$(TOUCH)

#
# host-opkg
#
HOST_OPKG_VER    = $(OPKG_VER)
HOST_OPKG_DIR    = opkg-$(HOST_OPKG_VER)
HOST_OPKG_SOURCE = $(OPKG_SOURCE)

HOST_OPKG_PATCH  = \
	opkg.patch

$(D)/host-opkg: directories host-libarchive $(ARCHIVE)/$(HOST_OPKG_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HOST_OPKG_DIR)
	$(UNTAR)/$(HOST_OPKG_SOURCE)
	$(CHDIR)/$(HOST_OPKG_DIR); \
		$(call apply_patches, $(HOST_OPKG_PATCH)); \
		./autogen.sh $(SILENT_OPT); \
		CFLAGS="-I$(HOST_DIR)/include" \
		LDFLAGS="-L$(HOST_DIR)/lib" \
		./configure $(SILENT_OPT) \
			PKG_CONFIG_PATH=$(HOST_DIR)/lib/pkgconfig \
			--prefix= \
			--disable-curl \
			--disable-gpg \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(HOST_DIR)
	$(REMOVE)/$(HOST_OPKG_DIR)
	$(TOUCH)
