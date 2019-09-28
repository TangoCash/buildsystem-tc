#
# luajson
#
LUAJSON_SOURCE = json.lua
LUAJSON_URL    = https://github.com/swiboe/swiboe/raw/master/term_gui

$(ARCHIVE)/$(LUAJSON_SOURCE):
	$(DOWNLOAD) $(LUAJSON_URL)/$(LUAJSON_SOURCE)

$(D)/luajson: bootstrap lua $(ARCHIVE)/$(LUAJSON_SOURCE)
	$(START_BUILD)
	cp $(ARCHIVE)/json.lua $(TARGET_SHARE_DIR)/lua/$(LUA_ABIVER)/json.lua
	$(TOUCH)
