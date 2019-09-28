#
# luacurl
#
LUACURL_VER    = e0b1d2ee
LUACURL_DIR    = luacurl-$(LUACURL_VER)
LUACURL_SOURCE = luacurl-$(LUACURL_VER).tar.bz2
LUACURL_URL    = git://github.com/Lua-cURL/Lua-cURLv3.git

$(ARCHIVE)/$(LUACURL_SOURCE):
	$(HELPERS_DIR)/get-git-archive.sh $(LUACURL_URL) $(LUACURL_VER) $(notdir $@) $(ARCHIVE)

$(D)/luacurl: bootstrap libcurl lua $(ARCHIVE)/$(LUACURL_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LUACURL_DIR)
	$(UNTAR)/$(LUACURL_SOURCE)
	$(CHDIR)/$(LUACURL_DIR); \
		$(MAKE) CC=$(TARGET_CC) LDFLAGS="-L$(TARGET_LIB_DIR)" \
			LIBDIR=$(TARGET_LIB_DIR) \
			LUA_INC=$(TARGET_INCLUDE_DIR); \
		$(MAKE) install LUA_CMOD=$(TARGET_LIB_DIR)/lua/$(LUA_ABIVER) LUA_LMOD=$(TARGET_SHARE_DIR)/lua/$(LUA_ABIVER)
	$(REMOVE)/$(LUACURL_DIR)
	$(TOUCH)
