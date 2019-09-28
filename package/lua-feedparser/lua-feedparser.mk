#
# lua-feedparser
#
LUA_FEEDPARSER_VER    = 0.71
LUA_FEEDPARSER_DIR    = lua-feedparser-$(LUA_FEEDPARSER_VER)
LUA_FEEDPARSER_SOURCE = lua-feedparser-$(LUA_FEEDPARSER_VER).tar.gz
LUA_FEEDPARSER_URL    = https://github.com/slact/lua-feedparser/archive

$(ARCHIVE)/$(LUA_FEEDPARSER_SOURCE):
	$(DOWNLOAD) $(LUA_FEEDPARSER_URL)/$(LUA_FEEDPARSER_VER).tar.gz -O $@

$(D)/lua-feedparser: bootstrap lua luasocket luaexpat $(ARCHIVE)/$(LUA_FEEDPARSER_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LUA_FEEDPARSER_DIR)
	$(UNTAR)/$(LUA_FEEDPARSER_SOURCE)
	$(CHDIR)/$(LUA_FEEDPARSER_DIR); \
		sed -i -e "s/^PREFIX.*//" -e "s/^LUA_DIR.*//" Makefile ; \
		$(BUILD_ENV) $(MAKE) install LUA_DIR=$(TARGET_SHARE_DIR)/lua/$(LUA_ABIVER)
	$(REMOVE)/$(LUA_FEEDPARSER_DIR)
	$(TOUCH)
