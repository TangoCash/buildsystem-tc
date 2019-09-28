#
# luasocket
#
LUASOCKET_VER    = 5a17f79
LUASOCKET_DIR    = luasocket-$(LUASOCKET_VER)
LUASOCKET_SOURCE = luasocket-$(LUASOCKET_VER).tar.bz2
LUASOCKET_URL    = git://github.com/diegonehab/luasocket.git

$(ARCHIVE)/$(LUASOCKET_SOURCE):
	$(HELPERS_DIR)/get-git-archive.sh $(LUASOCKET_URL) $(LUASOCKET_VER) $(notdir $@) $(ARCHIVE)

$(D)/luasocket: bootstrap lua $(ARCHIVE)/$(LUASOCKET_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LUASOCKET_DIR)
	$(UNTAR)/$(LUASOCKET_SOURCE)
	$(CHDIR)/$(LUASOCKET_DIR); \
		sed -i -e "s@LD_linux=gcc@LD_LINUX=$(TARGET_CC)@" -e "s@CC_linux=gcc@CC_LINUX=$(TARGET_CC) -L$(TARGET_LIB_DIR)@" -e "s@DESTDIR?=@DESTDIR?=$(TARGET_DIR)/usr@" src/makefile; \
		$(MAKE) CC=$(TARGET)-gcc LD=$(TARGET)-gcc LUAV=$(LUA_ABIVER) PLAT=linux COMPAT=COMPAT LUAINC_linux=$(TARGET_INCLUDE_DIR) LUAPREFIX_linux=; \
		$(MAKE) install LUAPREFIX_linux= LUAV=$(LUA_ABIVER)
	$(REMOVE)/$(LUASOCKET_DIR)
	$(TOUCH)
