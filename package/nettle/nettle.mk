#
# nettle
#
NETTLE_VER    = 3.5.1
NETTLE_DIR    = nettle-$(NETTLE_VER)
NETTLE_SOURCE = nettle-$(NETTLE_VER).tar.gz
NETTLE_URL    = https://ftp.gnu.org/gnu/nettle

$(ARCHIVE)/$(NETTLE_SOURCE):
	$(DOWNLOAD) $(NETTLE_URL)/$(NETTLE_SOURCE)

$(D)/nettle: bootstrap gmp $(ARCHIVE)/$(NETTLE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(NETTLE_DIR)
	$(UNTAR)/$(NETTLE_SOURCE)
	$(CHDIR)/$(NETTLE_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--disable-documentation \
		        ; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(NETTLE_DIR)
	$(TOUCH)
