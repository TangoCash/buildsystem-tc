#
# popt
#
POPT_VER    = 1.16
POPT_DIR    = popt-$(POPT_VER)
POPT_SOURCE = popt-$(POPT_VER).tar.gz
POPT_URL    = ftp://anduin.linuxfromscratch.org/BLFS/popt

$(ARCHIVE)/$(POPT_SOURCE):
	$(DOWNLOAD) $(POPT_URL)/$(POPT_SOURCE)

$(D)/popt: bootstrap $(ARCHIVE)/$(POPT_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(POPT_DIR)
	$(UNTAR)/$(POPT_SOURCE)
	$(CHDIR)/$(POPT_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--localedir=/.remove/locale \
			--disable-static \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libpopt.la
	$(REMOVE)/$(POPT_DIR)
	$(TOUCH)
