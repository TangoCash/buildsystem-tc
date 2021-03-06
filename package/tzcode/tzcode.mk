#
# host-tzdata
#
HOST_TZCODE_VER    = 2020a
HOST_TZCODE_DIR    = tzcode
HOST_TZCODE_SOURCE = tzcode$(HOST_TZCODE_VER).tar.gz
HOST_TZCODE_URL    = ftp://ftp.iana.org/tz/releases

$(ARCHIVE)/$(HOST_TZCODE_SOURCE):
	$(DOWNLOAD) $(HOST_TZCODE_URL)/$(HOST_TZCODE_SOURCE)

$(D)/host-tzcode: bootstrap $(ARCHIVE)/$(HOST_TZCODE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HOST_TZCODE_DIR)
	$(MKDIR)/$(HOST_TZCODE_DIR)
	$(CHDIR)/$(HOST_TZCODE_DIR); \
		tar -xf $(ARCHIVE)/$(HOST_TZCODE_SOURCE); \
		tar -xf $(ARCHIVE)/$(TZDATA_SOURCE); \
		$(MAKE) zic
	$(INSTALL_EXEC) -D $(BUILD_DIR)/$(HOST_TZCODE_DIR)/zic $(HOST_DIR)/bin/
	$(REMOVE)/$(HOST_TZCODE_DIR)
	$(TOUCH)
