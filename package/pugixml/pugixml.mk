#
# pugixml
#
PUGIXML_VER    = 1.10
PUGIXML_DIR    = pugixml-$(PUGIXML_VER)
PUGIXML_SOURCE = pugixml-$(PUGIXML_VER).tar.gz
PUGIXML_URL    = https://github.com/zeux/pugixml/releases/download/v$(PUGIXML_VER)

$(ARCHIVE)/$(PUGIXML_SOURCE):
	$(DOWNLOAD) $(PUGIXML_URL)/$(PUGIXML_SOURCE)

PUGIXML_PATCH  = \
	pugixml-config.patch

$(D)/pugixml: bootstrap $(ARCHIVE)/$(PUGIXML_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(PUGIXML_DIR)
	$(UNTAR)/$(PUGIXML_SOURCE)
	$(CHDIR)/$(PUGIXML_DIR); \
		$(call apply_patches, $(PUGIXML_PATCH)); \
		$(CMAKE) \
			| tail -n +90 \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	cd $(TARGET_DIR) && rm -rf usr/lib/cmake
	$(REMOVE)/$(PUGIXML_DIR)
	$(TOUCH)
