#
# ca-bundle
#
CA_BUNDLE_SOURCE = cacert.pem
CA_BUNDLE_URL    = https://curl.haxx.se/ca/$(CA_BUNDLE_SOURCE)

$(ARCHIVE)/$(CA_BUNDLE_SOURCE):
	$(DOWNLOAD) $(CA_BUNDLE_URL)

$(D)/ca-bundle: $(ARCHIVE)/$(CA_BUNDLE_SOURCE)
	$(START_BUILD)
	cd $(ARCHIVE); \
		curl --silent --remote-name --time-cond $(CA_BUNDLE_SOURCE) $(CA_BUNDLE_URL)
	$(INSTALL_DATA) -D $(ARCHIVE)/$(CA_BUNDLE_SOURCE) $(TARGET_DIR)/$(CA_BUNDLE_DIR)/$(CA_BUNDLE)
	$(TOUCH)
