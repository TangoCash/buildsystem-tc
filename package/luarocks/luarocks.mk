#
# host-luarocks
#
HOST_LUAROCKS_VER    = 3.1.3
HOST_LUAROCKS_DIR    = luarocks-$(HOST_LUAROCKS_VER)
HOST_LUAROCKS_SOURCE = luarocks-$(HOST_LUAROCKS_VER).tar.gz
HOST_LUAROCKS_URL    = https://luarocks.github.io/luarocks/releases
HOST_LUAROCKS_CONFIG = $(HOST_DIR)/etc/luarocks/config-$(LUA_ABIVER).lua
HOST_LUAROCKS_BINARY = $(HOST_DIR)/bin/luarocks

$(ARCHIVE)/$(HOST_LUAROCKS_SOURCE):
	$(DOWNLOAD) $(HOST_LUAROCKS_URL)/$(HOST_LUAROCKS_SOURCE)

HOST_LUAROCKS_PATCH  = \
	0001-allow-libluajit-detection.patch

HOST_LUAROCKS_BUILD_ENV = \
	LUA_PATH="$(HOST_DIR)/share/lua/$(LUA_ABIVER)/?.lua" \
	TARGET_CC="$(TARGET_CC)" \
	TARGET_LD="$(TARGET_LD)" \
	TARGET_CFLAGS="$(TARGET_CFLAGS) -fPIC" \
	TARGET_LDFLAGS="-L$(TARGET_LIB_DIR)" \
	TARGET_DIR="$(TARGET_DIR)"

$(D)/host-luarocks: directories host-lua lua $(ARCHIVE)/$(HOST_LUAROCKS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HOST_LUAROCKS_DIR)
	$(UNTAR)/$(HOST_LUAROCKS_SOURCE)
	$(CHDIR)/$(HOST_LUAROCKS_DIR); \
		$(call apply_patches, $(HOST_LUAROCKS_PATCH)); \
		./configure $(SILENT_OPT) \
			--prefix=$(HOST_DIR) \
			--sysconfdir=$(HOST_DIR)/etc \
			--with-lua=$(HOST_DIR) \
			; \
		$(MAKE); \
		$(MAKE) install
	cat $(PKG_FILES_DIR)/luarocks-config.lua >> $(HOST_LUAROCKS_CONFIG)
	$(REMOVE)/$(HOST_LUAROCKS_DIR)
	$(TOUCH)
