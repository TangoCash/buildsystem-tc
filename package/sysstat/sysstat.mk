#
# sysstat
#
SYSSTAT_VER    = 12.1.5
SYSSTAT_DIR    = sysstat-$(SYSSTAT_VER)
SYSSTAT_SOURCE = sysstat-$(SYSSTAT_VER).tar.xz
SYSSTAT_URL    = http://pagesperso-orange.fr/sebastien.godard

$(ARCHIVE)/$(SYSSTAT_SOURCE):
	$(DOWNLOAD) $(SYSSTAT_URL)/$(SYSSTAT_SOURCE)

$(D)/sysstat: bootstrap $(ARCHIVE)/$(SYSSTAT_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(SYSSTAT_DIR)
	$(UNTAR)/$(SYSSTAT_SOURCE)
	$(CHDIR)/$(SYSSTAT_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--docdir=/.remove \
			--disable-documentation \
			--disable-largefile \
			--disable-sensors \
			--disable-nls \
			sa_lib_dir="/usr/lib/sysstat" \
			sa_dir="/var/log/sysstat" \
			conf_dir="/etc/sysstat" \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR) NLS_DIR=/.remove/locale
	$(REMOVE)/$(SYSSTAT_DIR)
	$(TOUCH)
