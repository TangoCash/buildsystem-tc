#
# lsb
#
LSB_VER    = 3.2-20
LSB_DIR    = lsb-3.2
LSB_SOURCE = lsb_$(LSB_VER).tar.gz
LSB_URL    = https://debian.sdinet.de/etch/sdinet/lsb

$(ARCHIVE)/$(LSB_SOURCE):
	$(DOWNLOAD) $(LSB_URL)/$(LSB_SOURCE)

$(D)/lsb: bootstrap $(ARCHIVE)/$(LSB_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LSB_DIR)
	$(UNTAR)/$(LSB_SOURCE)
	$(CHDIR)/$(LSB_DIR); \
		$(INSTALL_DATA) init-functions $(TARGET_DIR)/lib/lsb
	$(REMOVE)/$(LSB_DIR)
	$(TOUCH)
