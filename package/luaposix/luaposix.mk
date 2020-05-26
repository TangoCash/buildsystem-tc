#
# luaposix
#
LUAPOSIX_VER    = 31
LUAPOSIX_DIR    = luaposix-$(LUAPOSIX_VER)
LUAPOSIX_SOURCE = luaposix-$(LUAPOSIX_VER).tar.gz
LUAPOSIX_URL    = git://github.com/luaposix/luaposix.git

$(ARCHIVE)/$(LUAPOSIX_SOURCE):
	$(DOWNLOAD) https://github.com/luaposix/luaposix/archive/v$(LUAPOSIX_VER).tar.gz -O $@

GNULIB_VER       = 20140202
GNULIB_SOURCE    = gnulib-$(GNULIB_VER)-stable.tar.gz

$(ARCHIVE)/$(GNULIB_SOURCE):
	$(DOWNLOAD) http://erislabs.net/ianb/projects/gnulib/$(GNULIB_SOURCE)

SLINGSHOT_VER    = 6
SLINGSHOT_SOURCE = slingshot-$(SLINGSHOT_VER).tar.gz

$(ARCHIVE)/$(SLINGSHOT_SOURCE):
	$(DOWNLOAD) https://github.com/gvvaughan/slingshot/archive/v$(SLINGSHOT_VER).tar.gz -O $@

LUAPOSIX_PATCH   = \
	0001-fix-docdir-build.patch

$(D)/luaposix: bootstrap host-lua lua luaexpat $(ARCHIVE)/$(SLINGSHOT_SOURCE) $(ARCHIVE)/$(GNULIB_SOURCE) $(ARCHIVE)/$(LUAPOSIX_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LUAPOSIX_DIR)
	$(UNTAR)/$(LUAPOSIX_SOURCE)
	$(CHDIR)/$(LUAPOSIX_DIR); \
		tar -C gnulib --strip=1 -xf $(ARCHIVE)/$(GNULIB_SOURCE); \
		tar -C slingshot --strip=1 -xf $(ARCHIVE)/$(SLINGSHOT_SOURCE); \
		$(call apply_patches, $(LUAPOSIX_PATCH)); \
		export LUA=$(HOST_LUA_BINARY); \
		./bootstrap $(SILENT_OPT); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--exec-prefix=/usr \
			--libdir=$(TARGET_LIB_DIR)/lua/$(LUA_ABIVER) \
			--datarootdir=$(TARGET_SHARE_DIR)/lua/$(LUA_ABIVER) \
			--mandir=$(TARGET_DIR)/.remove \
			--docdir=$(TARGET_DIR)/.remove \
			--enable-silent-rules \
			; \
		$(MAKE); \
		$(MAKE) install
	$(REMOVE)/$(LUAPOSIX_DIR)
	$(TOUCH)
