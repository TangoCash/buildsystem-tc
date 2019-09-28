#
# shairport-sync
#
SHAIRPORT_SYNC_VER    = git
SHAIRPORT_SYNC_DIR    = shairport-sync.$(SHAIRPORT_SYNC_VER)
SHAIRPORT_SYNC_SOURCE = $(SHAIRPORT_SYNC_DIR)
SHAIRPORT_SYNC_URL    = https://github.com/mikebrady/shairport-sync.git

$(D)/shairport-sync: bootstrap libdaemon popt libconfig openssl alsa-lib
	$(START_BUILD)
	$(REMOVE)/$(SHAIRPORT_SYNC_DIR)
	$(GET-GIT-SOURCE) $(SHAIRPORT_SYNC_URL) $(ARCHIVE)/$(SHAIRPORT_SYNC_SOURCE)
	$(CPDIR)/$(SHAIRPORT_SYNC_DIR)
	$(CHDIR)/$(SHAIRPORT_SYNC_DIR); \
		autoreconf -fi $(SILENT_OPT); \
		$(BUILD_ENV) \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--with-alsa \
			--with-ssl=openssl \
			--with-metadata \
			--with-tinysvcmdns \
			--with-pipe \
			--with-stdout \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(SHAIRPORT_SYNC_DIR)
	$(TOUCH)
