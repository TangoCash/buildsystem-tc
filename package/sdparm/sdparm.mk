#
# sdparm
#
SDPARM_VER    = 1.11
SDPARM_DIR    = sdparm-$(SDPARM_VER)
SDPARM_SOURCE = sdparm-$(SDPARM_VER).tgz
SDPARM_URL    = http://sg.danny.cz/sg/p

$(ARCHIVE)/$(SDPARM_SOURCE):
	$(DOWNLOAD) $(SDPARM_URL)/$(SDPARM_SOURCE)

$(D)/sdparm: bootstrap $(ARCHIVE)/$(SDPARM_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(SDPARM_DIR)
	$(UNTAR)/$(SDPARM_SOURCE)
	$(CHDIR)/$(SDPARM_DIR); \
		$(CONFIGURE) \
			--prefix= \
			--bindir=/sbin \
			--mandir=/.remove \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	rm -f $(addprefix $(TARGET_DIR)/sbin/,sas_disk_blink scsi_ch_swp)
	$(REMOVE)/$(SDPARM_DIR)
	$(TOUCH)
