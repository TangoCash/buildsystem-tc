#
# shairport
#
SHAIRPORT_VER      = git
SHAIRPORT_DIR      = shairport.$(SHAIRPORT_VER)
SHAIRPORT_SOURCE   = $(SHAIRPORT_DIR)
SHAIRPORT_URL      = https://github.com/abrasive/shairport.git
SHAIRPORT_CHECKOUT = 1.0-dev

$(D)/shairport: bootstrap openssl howl alsa-lib
	$(START_BUILD)
	$(REMOVE)/$(SHAIRPORT_DIR)
	$(GET-GIT-SOURCE) $(SHAIRPORT_URL) $(ARCHIVE)/$(SHAIRPORT_SOURCE)
	$(CPDIR)/$(SHAIRPORT_DIR)
	$(CHDIR)/$(SHAIRPORT_DIR); git checkout -q $(SHAIRPORT_CHECKOUT); \
	$(CHDIR)/$(SHAIRPORT_DIR); \
		$(BUILD_ENV) \
		$(MAKE); \
		$(MAKE) install PREFIX=$(TARGET_DIR)/usr
	$(REMOVE)/$(SHAIRPORT_DIR)
	$(TOUCH)
