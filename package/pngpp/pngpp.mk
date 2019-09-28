#
# pngpp
#
PNGPP_VER    = 0.2.9
PNGPP_DIR    = png++-$(PNGPP_VER)
PNGPP_SOURCE = png++-$(PNGPP_VER).tar.gz
PNGPP_URL    = https://download.savannah.gnu.org/releases/pngpp

$(ARCHIVE)/$(PNGPP_SOURCE):
	$(DOWNLOAD) $(PNGPP_URL)/$(PNGPP_SOURCE)

$(D)/pngpp: bootstrap libpng $(ARCHIVE)/$(PNGPP_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(PNGPP_DIR)
	$(UNTAR)/$(PNGPP_SOURCE)
	$(CHDIR)/$(PNGPP_DIR); \
		$(MAKE) install-headers PREFIX=$(TARGET_DIR)/usr
	$(REMOVE)/$(PNGPP_DIR)
	$(TOUCH)
