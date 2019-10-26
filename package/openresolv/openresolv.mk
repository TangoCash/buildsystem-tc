#
# openresolv
#
OPENRESOLV_VER    = 3.9.2
OPENRESOLV_DIR    = openresolv-$(OPENRESOLV_VER)
OPENRESOLV_SOURCE = openresolv-$(OPENRESOLV_VER).tar.xz
OPENRESOLV_URL    = https://roy.marples.name/downloads/openresolv

$(ARCHIVE)/$(OPENRESOLV_SOURCE):
	$(DOWNLOAD) $(OPENRESOLV_URL)/$(OPENRESOLV_SOURCE)

$(D)/openresolv: bootstrap $(ARCHIVE)/$(OPENRESOLV_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(OPENRESOLV_DIR)
	$(UNTAR)/$(OPENRESOLV_SOURCE)
	$(CHDIR)/$(OPENRESOLV_DIR); \
		$(CONFIGURE) \
			--prefix= \
			--sysconfdir=/etc \
			--mandir=/.remove \
			--rundir=/var/run/resolvconf \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(OPENRESOLV_DIR)
	$(TOUCH)
