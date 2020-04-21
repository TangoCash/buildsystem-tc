#
# vpnc
#
VPNC_VER    = 0.5.3
VPNC_DIR    = vpnc-$(VPNC_VER)
VPNC_SOURCE = vpnc-$(VPNC_VER).tar.gz
VPNC_URL    = https://fossies.org/linux/privat

$(ARCHIVE)/$(VPNC_SOURCE):
	$(DOWNLOAD) $(VPNC_URL)/$(VPNC_SOURCE)

VPNC_PATCH  = \
	0001-fix-build.patch \
	0002-nomanual.patch \
	0003-susv3-legacy.patch

VPNC_CPPFLAGS = -DVERSION=\\\"$(VPNC_VER)\\\"

$(D)/vpnc: bootstrap openssl lzo libgcrypt $(ARCHIVE)/$(VPNC_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(VPNC_DIR)
	$(UNTAR)/$(VPNC_SOURCE)
	$(CHDIR)/$(VPNC_DIR); \
		$(call apply_patches, $(VPNC_PATCH)); \
		$(BUILD_ENV) \
		$(MAKE) \
			CPPFLAGS="$(CPPFLAGS) $(VPNC_CPPFLAGS)"; \
		$(MAKE) \
			CPPFLAGS="$(CPPFLAGS) $(VPNC_CPPFLAGS)" \
			install DESTDIR=$(TARGET_DIR) \
			PREFIX=/usr \
			MANDIR=$(TARGET_DIR)/.remove \
			DOCDIR=$(TARGET_DIR)/.remove
	$(REMOVE)/vpnc-$(VPNC_VER)
	$(TOUCH)
