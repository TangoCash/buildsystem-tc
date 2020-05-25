#
# udpxy
#
UDPXY_VER    = git
UDPXY_DIR    = udpxy.$(UDPXY_VER)
UDPXY_SOURCE = udpxy.$(UDPXY_VER)
UDPXY_URL    = https://github.com/pcherenkov

UDPXY_PATCH  = \
	0001-udpxy.patch \
	0002-fix-build-with-gcc8.patch

$(D)/udpxy: bootstrap
	$(START_BUILD)
	$(REMOVE)/$(UDPXY_DIR)
	$(GET-GIT-SOURCE) $(UDPXY_URL)/$(UDPXY_SOURCE) $(ARCHIVE)/$(UDPXY_SOURCE)
	$(CPDIR)/$(UDPXY_DIR)
	$(CHDIR)/$(UDPXY_DIR)/chipmunk; \
		$(call apply_patches, $(UDPXY_PATCH)); \
		$(BUILD_ENV) \
		$(MAKE) CC=$(TARGET_CC); \
		$(MAKE) install INSTALLROOT=$(TARGET_DIR)/usr MANPAGE_DIR=$(TARGET_DIR)/.remove
	$(REMOVE)/$(UDPXY_DIR)
	$(TOUCH)
