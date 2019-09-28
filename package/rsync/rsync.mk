#
# rsync
#
RSYNC_VER    = 3.1.3
RSYNC_DIR    = rsync-$(RSYNC_VER)
RSYNC_SOURCE = rsync-$(RSYNC_VER).tar.gz
RSYNC_URL    = https://ftp.samba.org/pub/rsync

$(ARCHIVE)/$(RSYNC_SOURCE):
	$(DOWNLOAD) $(RSYNC_URL)/$(RSYNC_SOURCE)

RSYNC_PATCH  = \
	001-rsync-sysmacros.patch

$(D)/rsync: bootstrap $(ARCHIVE)/$(RSYNC_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(RSYNC_DIR)
	$(UNTAR)/$(RSYNC_SOURCE)
	$(CHDIR)/$(RSYNC_DIR); \
		$(call apply_patches, $(RSYNC_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--sysconfdir=/etc \
			--disable-debug \
			--disable-locale \
			; \
		$(MAKE) all; \
		$(MAKE) install-all DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(RSYNC_DIR)
	$(TOUCH)
