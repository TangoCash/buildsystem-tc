#
# lua
#
LUA_VER    = 5.2.4
LUA_ABIVER = $(basename $(LUA_VER))
LUA_DIR    = lua-$(LUA_VER)
LUA_SOURCE = lua-$(LUA_VER).tar.gz
LUA_URL    = https://www.lua.org

$(ARCHIVE)/$(LUA_SOURCE):
	$(DOWNLOAD) $(LUA_URL)/ftp/$(LUA_SOURCE)

LUA_PATCH  = \
	0001-fix-lua-root.patch \
	0002-remove-readline.patch \
	0003-shared-library.patch \
	0004-lua-pc.patch \
	0005-crashfix.patch

$(D)/lua: bootstrap host-lua ncurses $(ARCHIVE)/$(LUA_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LUA_DIR)
	$(UNTAR)/$(LUA_SOURCE)
	$(CHDIR)/$(LUA_DIR); \
		$(call apply_patches, $(LUA_PATCH)); \
		$(MAKE) linux \
			PKG_VERSION=$(LUA_VER) \
			$(MAKE_OPTS) \
			AR="$(TARGET_AR) rcu" \
			LDFLAGS="$(TARGET_LDFLAGS)" \
			; \
		$(MAKE) INSTALL_TOP=$(TARGET_DIR)/usr \
			INSTALL_DATA="cp -d" \
			INSTALL_MAN=$(TARGET_DIR)/.remove install \
			TO_LIB="liblua.so liblua.so.$(LUA_ABIVER) liblua.so.$(LUA_VER)"
	$(INSTALL_DATA) -D $(BUILD_DIR)/lua-$(LUA_VER)/etc/lua.pc $(PKG_CONFIG_PATH)/lua.pc
	rm -rf $(addprefix $(TARGET_DIR)/bin/,luac)
	$(REMOVE)/$(LUA_DIR)
	$(TOUCH)

#
# host-lua
#
HOST_LUA_VER    = $(LUA_VER)
HOST_LUA_DIR    = lua-$(HOST_LUA_VER)
HOST_LUA_SOURCE = lua-$(LUA_VER).tar.gz

HOST_LUA_PATCH  = \
	0001-fix-lua-root.patch \
	0002-remove-readline.patch

HOST_LUA_BINARY = $(HOST_DIR)/bin/lua

$(D)/host-lua: directories $(ARCHIVE)/$(HOST_LUA_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HOST_LUA_DIR)
	$(UNTAR)/$(HOST_LUA_SOURCE)
	$(CHDIR)/$(HOST_LUA_DIR); \
		$(call apply_patches, $(HOST_LUA_PATCH)); \
		$(MAKE) linux; \
		$(MAKE) install INSTALL_TOP=$(HOST_DIR)
	$(REMOVE)/$(HOST_LUA_DIR)
	$(TOUCH)
