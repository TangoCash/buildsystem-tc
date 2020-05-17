#
# xupnpd
#
XUPNPD_VER    = 25d6d44
XUPNPD_DIR    = xupnpd.git
XUPNPD_SOURCE = xupnpd.git
XUPNPD_URL    = https://github.com/clark15b

XUPNPD_PATCH  =  \
	xupnpd.patch

$(D)/xupnpd: bootstrap lua openssl neutrino-plugins
	$(START_BUILD)
	$(REMOVE)/$(XUPNPD_DIR)
	$(GET-GIT-SOURCE) $(XUPNPD_URL)/$(XUPNPD_SOURCE) $(ARCHIVE)/$(XUPNPD_SOURCE)
	$(CPDIR)/$(XUPNPD_DIR)
	$(CHDIR)/$(XUPNPD_DIR); \
		git checkout -q $(XUPNPD_VER); \
		$(call apply_patches, $(XUPNPD_PATCH)); \
	$(CHDIR)/$(XUPNPD_DIR)/src; \
		$(BUILD_ENV) \
		$(MAKE) embedded TARGET=$(TARGET) PKG_CONFIG=$(PKG_CONFIG) LUAFLAGS="$(TARGET_LDFLAGS) -I$(TARGET_INCLUDE_DIR)"; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/xupnpd.init $(TARGET_DIR)/etc/init.d/xupnpd
	mkdir -p $(TARGET_DIR)/usr/share/xupnpd/{config,playlists}
	rm $(TARGET_DIR)/usr/share/xupnpd/plugins/staff/xupnpd_18plus.lua
	$(INSTALL_DATA) $(ARCHIVE)/$(NEUTRINO_PLUGINS_DIR)/scripts-lua/xupnpd/xupnpd_18plus.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	$(INSTALL_DATA) $(ARCHIVE)/$(NEUTRINO_PLUGINS_DIR)/scripts-lua/xupnpd/xupnpd_youtube.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	: $(INSTALL_DATA) $(ARCHIVE)/$(NEUTRINO_PLUGINS_DIR)/scripts-lua/xupnpd/xupnpd_coolstream.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	$(INSTALL_DATA) $(ARCHIVE)/$(NEUTRINO_PLUGINS_DIR)/scripts-lua/xupnpd/xupnpd_cczwei.lua ${TARGET_DIR}/usr/share/xupnpd/plugins/
	$(UPDATE-RC.D) xupnpd defaults 50
	$(REMOVE)/$(XUPNPD_DIR)
	$(TOUCH)
