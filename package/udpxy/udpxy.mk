#
# udpxy
#
UDPXY_VER    = git
UDPXY_DIR    = udpxy.git
UDPXY_SOURCE = $(UDPXY_DIR)
UDPXY_URL    = https://github.com/pcherenkov/$(UDPXY_SOURCE)

UDPXY_PATCH  = \
	udpxy.patch \
	fix-build-with-gcc8.patch

$(D)/udpxy: bootstrap
	$(START_BUILD)
	$(REMOVE)/$(UDPXY_DIR)
	$(GET-GIT-SOURCE) $(UDPXY_URL) $(ARCHIVE)/$(UDPXY_SOURCE)
	$(CPDIR)/$(UDPXY_DIR)
	$(CHDIR)/$(UDPXY_DIR)/chipmunk; \
		$(call apply_patches, $(UDPXY_PATCH)); \
		$(BUILD_ENV) \
		$(MAKE) CC=$(TARGET_CC); \
		$(MAKE) install INSTALLROOT=$(TARGET_DIR)/usr MANPAGE_DIR=$(TARGET_DIR)/.remove
	$(REMOVE)/$(UDPXY_DIR)
	$(TOUCH)
