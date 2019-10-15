#
# graphlcd
#
GRAPHLCD_VER    = git
GRAPHLCD_DIR    = graphlcd.$(GRAPHLCD_VER)
GRAPHLCD_SOURCE = $(GRAPHLCD_DIR)
GRAPHLCD_URL    = git://projects.vdr-developer.org/graphlcd-base.git

GRAPHLCD_PATCH  = \
	graphlcd.patch

ifeq ($(BOXMODEL), $(filter $(BOXMODEL), vuduo4k vusolo4k vuultimo4k vuuno4kse))
GRAPHLCD_PATCH += \
	graphlcd-vuplus.patch
endif

$(D)/graphlcd: bootstrap freetype libiconv libusb
	$(START_BUILD)
	$(REMOVE)/$(GRAPHLCD_DIR)
	$(GET-GIT-SOURCE) $(GRAPHLCD_URL) $(ARCHIVE)/$(GRAPHLCD_SOURCE)
	$(CPDIR)/$(GRAPHLCD_DIR)
	$(CHDIR)/$(GRAPHLCD_DIR); \
		$(call apply_patches, $(GRAPHLCD_PATCH)); \
		$(MAKE) -C glcdgraphics all TARGET=$(TARGET_CROSS) DESTDIR=$(TARGET_DIR); \
		$(MAKE) -C glcddrivers all TARGET=$(TARGET_CROSS) DESTDIR=$(TARGET_DIR); \
		$(MAKE) -C glcdgraphics install DESTDIR=$(TARGET_DIR); \
		$(MAKE) -C glcddrivers install DESTDIR=$(TARGET_DIR); \
		cp -a graphlcd.conf $(TARGET_DIR)/etc
	$(REMOVE)/$(GRAPHLCD_DIR)
	$(TOUCH)
