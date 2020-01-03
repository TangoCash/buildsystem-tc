#
# luaexpat
#
LUAEXPAT_VER    = 1.3.3
LUAEXPAT_DIR    = luaexpat-$(LUAEXPAT_VER)
LUAEXPAT_SOURCE = luaexpat-$(LUAEXPAT_VER).tar.gz
LUAEXPAT_URL    = https://github.com/tomasguisasola/luaexpat/archive

$(ARCHIVE)/$(LUAEXPAT_SOURCE):
	$(DOWNLOAD) $(LUAEXPAT_URL)/v$(LUAEXPAT_VER).tar.gz -O $@

$(D)/luaexpat: bootstrap lua expat $(ARCHIVE)/$(LUAEXPAT_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LUAEXPAT_DIR)
	$(UNTAR)/$(LUAEXPAT_SOURCE)
	$(CHDIR)/$(LUAEXPAT_DIR); \
		sed -i 's|^EXPAT_INC=.*|EXPAT_INC= $(TARGET_INCLUDE_DIR)|' makefile; \
		sed -i 's|^CFLAGS =.*|& -L$(TARGET_LIB_DIR)|' makefile; \
		sed -i 's|^CC =.*|CC = $(TARGET_CC)|' makefile; \
		$(MAKE) \
			PREFIX=$(TARGET_DIR)/usr \
			LUA_SYS_VER=$(LUA_ABIVER) \
			; \
		$(MAKE) install \
			PREFIX=$(TARGET_DIR)/usr \
			LUA_SYS_VER=$(LUA_ABIVER)
	$(REMOVE)/$(LUAEXPAT_DIR)
	$(TOUCH)
