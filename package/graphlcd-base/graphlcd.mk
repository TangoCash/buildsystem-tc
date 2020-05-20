#
# graphlcd-base
#
GRAPHLCD_BASE_VER    = git
GRAPHLCD_BASE_DIR    = graphlcd-base.$(GRAPHLCD_BASE_VER)
GRAPHLCD_BASE_SOURCE = graphlcd-base.$(GRAPHLCD_BASE_VER)
GRAPHLCD_BASE_URL    = git://projects.vdr-developer.org

GRAPHLCD_BASE_PATCH  = \
	graphlcd.patch

ifeq ($(BOXMODEL), $(filter $(BOXMODEL), vuduo4k vusolo4k vuultimo4k vuuno4kse))
GRAPHLCD_PATCH += \
	graphlcd-vuplus.patch
endif

$(D)/graphlcd-base: bootstrap freetype libiconv libusb
	$(START_BUILD)
	$(REMOVE)/$(GRAPHLCD_BASE_DIR)
	$(GET-GIT-SOURCE) $(GRAPHLCD_BASE_URL)/$(GRAPHLCD_BASE_SOURCE) $(ARCHIVE)/$(GRAPHLCD_BASE_SOURCE)
	$(CPDIR)/$(GRAPHLCD_BASE_DIR)
	$(CHDIR)/$(GRAPHLCD_BASE_DIR); \
		$(call apply_patches, $(GRAPHLCD_BASE_PATCH)); \
		$(MAKE) -C glcdgraphics all TARGET=$(TARGET_CROSS) DESTDIR=$(TARGET_DIR); \
		$(MAKE) -C glcddrivers all TARGET=$(TARGET_CROSS) DESTDIR=$(TARGET_DIR); \
		$(MAKE) -C glcdgraphics install DESTDIR=$(TARGET_DIR); \
		$(MAKE) -C glcddrivers install DESTDIR=$(TARGET_DIR); \
		cp -a graphlcd.conf $(TARGET_DIR)/etc
	$(REMOVE)/$(GRAPHLCD_BASE_DIR)
	$(TOUCH)
