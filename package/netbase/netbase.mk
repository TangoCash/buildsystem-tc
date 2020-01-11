#
# netbase
#
NETBASE_VER    = 5.8
NETBASE_DIR    = netbase-$(NETBASE_VER)
NETBASE_SOURCE = netbase_$(NETBASE_VER).tar.xz
NETBASE_URL    = http://ftp.debian.org/debian/pool/main/n/netbase/

$(ARCHIVE)/$(NETBASE_SOURCE):
	$(DOWNLOAD) $(NETBASE_URL)/$(NETBASE_SOURCE)

$(D)/netbase: bootstrap $(ARCHIVE)/$(NETBASE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(NETBASE_DIR)
	$(UNTAR)/$(NETBASE_SOURCE)
	$(CHDIR)/$(NETBASE_DIR); \
		$(INSTALL_DATA) etc-rpc $(TARGET_DIR)/etc/rpc; \
		$(INSTALL_DATA) etc-protocols $(TARGET_DIR)/etc/protocols; \
		$(INSTALL_DATA) etc-services $(TARGET_DIR)/etc/services; \
	$(REMOVE)/$(NETBASE_DIR)
	$(TOUCH)
