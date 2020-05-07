#
# vpnc
#
VPNC_VER    = 0.5.3r550-2jnpr1
VPNC_DIR    = vpnc-$(VPNC_VER)
VPNC_SOURCE = vpnc-$(VPNC_VER).tar.gz
VPNC_URL    = https://github.com/ndpgroup/vpnc/archive

$(ARCHIVE)/$(VPNC_SOURCE):
	$(DOWNLOAD) $(VPNC_URL)/$(VPNC_VER).tar.gz -O $(@)

VPNC_PATCH  = \
	0001-Makefile-allow-to-override-the-PREFIX-variable.patch \
	0002-nomanual.patch \
	0002-Makefile-allow-to-override-the-version.patch \
	0003-Makefile-allow-passing-custom-CFLAGS-CPPFLAGS.patch \
	0004-Makefile-provide-an-option-to-not-build-manpages.patch \
	0005-Makefile-allow-passing-a-custom-path-to-libgcrypt-co.patch \
	0006-config.c-Replace-deprecated-SUSv3-functions-with-POS.patch \
	0007-sysdep.h-don-t-assume-error.h-is-available-on-all-Li.patch \
	0008-sysdep.c-don-t-include-linux-if_tun.h-on-Linux.patch \
	0009-config.c-add-missing-sys-ttydefaults.h-include.patch

$(D)/vpnc: bootstrap openssl libgcrypt libgpg-error $(ARCHIVE)/$(VPNC_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(VPNC_DIR)
	$(UNTAR)/$(VPNC_SOURCE)
	$(CHDIR)/$(VPNC_DIR); \
		$(call apply_patches, $(VPNC_PATCH)); \
		$(BUILD_ENV) \
		$(MAKE); \
		$(MAKE) \
			install DESTDIR=$(TARGET_DIR) \
			PREFIX=/usr \
			MANDIR=/.remove \
			DOCDIR=/.remove
	$(REMOVE)/vpnc-$(VPNC_VER)
	$(TOUCH)
