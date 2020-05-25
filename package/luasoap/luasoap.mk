#
# luasoap
#
LUASOAP_VER    = 3.0
LUASOAP_DIR    = luasoap-$(LUASOAP_VER)
LUASOAP_SOURCE = luasoap-$(LUASOAP_VER).tar.gz
LUASOAP_URL    = https://github.com/downloads/tomasguisasola/luasoap

$(ARCHIVE)/$(LUASOAP_SOURCE):
	$(DOWNLOAD) $(LUASOAP_URL)/$(LUASOAP_SOURCE)

LUASOAP_PATCH  = \
	0001-luasoap.patch

$(D)/luasoap: bootstrap lua luasocket luaexpat $(ARCHIVE)/$(LUASOAP_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LUASOAP_DIR)
	$(UNTAR)/$(LUASOAP_SOURCE)
	$(CHDIR)/$(LUASOAP_DIR); \
		$(call apply_patches, $(LUASOAP_PATCH)); \
		$(MAKE) install LUA_DIR=$(TARGET_SHARE_DIR)/lua/$(LUA_ABIVER)
	$(REMOVE)/$(LUASOAP_DIR)
	$(TOUCH)
