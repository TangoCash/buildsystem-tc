#
# luaexpat
#
LUAEXPAT_VER    = 1.3.0
LUAEXPAT_DIR    = luaexpat-$(LUAEXPAT_VER)
LUAEXPAT_SOURCE = luaexpat-$(LUAEXPAT_VER).tar.gz
LUAEXPAT_URL    = https://matthewwild.co.uk/projects/luaexpat

$(ARCHIVE)/$(LUAEXPAT_SOURCE):
	$(DOWNLOAD) $(LUAEXPAT_URL)/$(LUAEXPAT_SOURCE)

LUAEXPAT_PATCH  = \
	luaexpat.patch

$(D)/luaexpat: bootstrap lua expat $(ARCHIVE)/$(LUAEXPAT_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LUAEXPAT_DIR)
	$(UNTAR)/$(LUAEXPAT_SOURCE)
	$(CHDIR)/$(LUAEXPAT_DIR); \
		$(call apply_patches, $(LUAEXPAT_PATCH)); \
		$(MAKE) CC=$(TARGET_CC) LDFLAGS="-L$(TARGET_LIB_DIR)" PREFIX=$(TARGET_DIR)/usr; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)/usr
	$(REMOVE)/$(LUAEXPAT_DIR)
	$(TOUCH)
