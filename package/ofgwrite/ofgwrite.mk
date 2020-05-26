#
# ofgwrite
#
OFGWRITE_VER    = git
OFGWRITE_DIR    = ofgwrite-max.$(OFGWRITE_VER)
OFGWRITE_SOURCE = ofgwrite-max.$(OFGWRITE_VER)
OFGWRITE_URL    = $(MAX-GIT-GITHUB)

$(D)/ofgwrite: bootstrap
	$(START_BUILD)
	$(REMOVE)/$(OFGWRITE_DIR)
	$(GET-GIT-SOURCE) $(OFGWRITE_URL)/$(OFGWRITE_SOURCE) $(ARCHIVE)/$(OFGWRITE_SOURCE)
	$(CPDIR)/$(OFGWRITE_DIR)
	$(CHDIR)/$(OFGWRITE_DIR); \
		$(BUILD_ENV) \
		$(MAKE); \
	$(INSTALL_EXEC) $(BUILD_DIR)/$(OFGWRITE_DIR)/ofgwrite_bin $(TARGET_DIR)/usr/bin
	$(INSTALL_EXEC) $(BUILD_DIR)/$(OFGWRITE_DIR)/ofgwrite_caller $(TARGET_DIR)/usr/bin
	$(INSTALL_EXEC) $(BUILD_DIR)/$(OFGWRITE_DIR)/ofgwrite $(TARGET_DIR)/usr/bin
	$(REMOVE)/$(OFGWRITE_DIR)
	$(TOUCH)
