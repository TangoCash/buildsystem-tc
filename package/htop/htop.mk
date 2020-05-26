#
# htop
#
HTOP_VER    = 2.2.0
HTOP_DIR    = htop-$(HTOP_VER)
HTOP_SOURCE = htop-$(HTOP_VER).tar.gz
HTOP_URL    = http://hisham.hm/htop/releases/$(HTOP_VER)

$(ARCHIVE)/$(HTOP_SOURCE):
	$(DOWNLOAD) $(HTOP_URL)/$(HTOP_SOURCE)

HTOP_PATCH  = \
	0001-Use-pkg-config.patch \
	0002-htop-sysmacros.patch

$(D)/htop: bootstrap ncurses $(ARCHIVE)/$(HTOP_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HTOP_DIR)
	$(UNTAR)/$(HTOP_SOURCE)
	$(CHDIR)/$(HTOP_DIR); \
		$(call apply_patches, $(HTOP_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--sysconfdir=/etc \
			--disable-unicode \
			--enable-cgroup \
			--enable-proc \
			--enable-taskstats \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	rm -rf $(addprefix $(TARGET_SHARE_DIR)/,pixmaps applications)
	ln -sf htop $(TARGET_DIR)/usr/bin/top
	$(REMOVE)/$(HTOP_DIR)
	$(TOUCH)
