#
# rtmpdump
#
RTMPDUMP_VER    = git
RTMPDUMP_DIR    = rtmpdump.$(RTMPDUMP_VER)
RTMPDUMP_SOURCE = rtmpdump.$(RTMPDUMP_VER)
RTMPDUMP_URL    = git://github.com/oe-alliance

RTMPDUMP_PATCH  = \
	rtmpdump.patch \
	fix-build-openssl102q.patch \
	fix-build-openssl111a.patch

$(D)/rtmpdump: bootstrap zlib openssl
	$(START_BUILD)
	$(REMOVE)/$(RTMPDUMP_DIR)
	$(GET-GIT-SOURCE) $(RTMPDUMP_URL)/$(RTMPDUMP_SOURCE) $(ARCHIVE)/$(RTMPDUMP_SOURCE)
	$(CPDIR)/$(RTMPDUMP_DIR)
	$(CHDIR)/$(RTMPDUMP_DIR); \
		$(call apply_patches, $(RTMPDUMP_PATCH)); \
		$(MAKE) CROSS_COMPILE=$(TARGET_CROSS) XCFLAGS="-I$(TARGET_INCLUDE_DIR) -L$(TARGET_LIB_DIR)" LDFLAGS="-L$(TARGET_LIB_DIR)"; \
		$(MAKE) install prefix=/usr DESTDIR=$(TARGET_DIR) MANDIR=$(TARGET_DIR)/.remove
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/,rtmpgw rtmpsrv rtmpsuck)
	$(REMOVE)/$(RTMPDUMP_DIR)
	$(TOUCH)
