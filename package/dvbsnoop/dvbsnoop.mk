#
# dvbsnoop
#
DVBSNOOP_VER    = git
DVBSNOOP_DIR    = dvbsnoop.$(DVBSNOOP_VER)
DVBSNOOP_SOURCE = dvbsnoop.$(DVBSNOOP_VER)
DVBSNOOP_URL    = https://github.com/Duckbox-Developers

$(D)/dvbsnoop: bootstrap kernel
	$(START_BUILD)
	$(REMOVE)/$(DVBSNOOP_DIR)
	$(GET-GIT-SOURCE) $(DVBSNOOP_URL)/$(DVBSNOOP_SOURCE) $(ARCHIVE)/$(DVBSNOOP_SOURCE)
	$(CPDIR)/$(DVBSNOOP_DIR)
	$(CHDIR)/$(DVBSNOOP_DIR); \
		$(CONFIGURE) \
			--enable-silent-rules \
			--prefix=/usr \
			--mandir=/.remove \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(DVBSNOOP_DIR)
	$(TOUCH)
