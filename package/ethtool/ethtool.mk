#
# ethtool
#
ETHTOOL_VER    = 5.3
ETHTOOL_DIR    = ethtool-$(ETHTOOL_VER)
ETHTOOL_SOURCE = ethtool-$(ETHTOOL_VER).tar.xz
ETHTOOL_URL    = https://www.kernel.org/pub/software/network/ethtool

$(ARCHIVE)/$(ETHTOOL_SOURCE):
	$(DOWNLOAD) $(ETHTOOL_URL)/$(ETHTOOL_SOURCE)

$(D)/ethtool: bootstrap $(ARCHIVE)/$(ETHTOOL_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(ETHTOOL_DIR)
	$(UNTAR)/$(ETHTOOL_SOURCE)
	$(CHDIR)/$(ETHTOOL_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--disable-pretty-dump \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(ETHTOOL_DIR)
	$(TOUCH)
