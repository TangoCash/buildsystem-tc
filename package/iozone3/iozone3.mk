#
# iozone3
#
IOZONE_VER    = 487
IOZONE_DIR    = iozone3_$(IOZONE_VER)
IOZONE_SOURCE = iozone3_$(IOZONE_VER).tar
IOZONE_URL    = http://www.iozone.org/src/current

$(ARCHIVE)/$(IOZONE_SOURCE):
	$(DOWNLOAD) $(IOZONE_URL)/$(IOZONE_SOURCE)

$(D)/iozone3: bootstrap $(ARCHIVE)/$(IOZONE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(IOZONE_DIR)
	$(UNTAR)/$(IOZONE_SOURCE)
	$(CHDIR)/$(IOZONE_DIR); \
		sed -i -e "s/= gcc/= $(TARGET_CC)/" src/current/makefile; \
		sed -i -e "s/= cc/= $(TARGET_CC)/" src/current/makefile; \
		cd src/current; \
		$(BUILD_ENV); \
		$(MAKE) linux-arm
		$(INSTALL_EXEC) $(BUILD_DIR)/$(IOZONE_DIR)/src/current/iozone $(TARGET_DIR)/usr/bin
	$(REMOVE)/$(IOZONE_DIR)
	$(TOUCH)
