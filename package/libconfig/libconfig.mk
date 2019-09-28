#
# libconfig
#
LIBCONFIG_VER    = 1.4.10
LIBCONFIG_DIR    = libconfig-$(LIBCONFIG_VER)
LIBCONFIG_SOURCE = libconfig-$(LIBCONFIG_VER).tar.gz
LIBCONFIG_URL    = http://www.hyperrealm.com/packages

$(ARCHIVE)/$(LIBCONFIG_SOURCE):
	$(DOWNLOAD) $(LIBCONFIG_URL)/$(LIBCONFIG_SOURCE)

$(D)/libconfig: bootstrap $(ARCHIVE)/$(LIBCONFIG_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBCONFIG_DIR)
	$(UNTAR)/$(LIBCONFIG_SOURCE)
	$(CHDIR)/$(LIBCONFIG_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--infodir=/.remove \
			--disable-static \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libconfig.la
	$(REWRITE_LIBTOOL)/libconfig++.la
	$(REMOVE)/$(LIBCONFIG_DIR)
	$(TOUCH)
