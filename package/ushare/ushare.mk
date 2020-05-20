USHARE_VER    = 1.1a
USHARE_DIR    = ushare-uShare_v$(USHARE_VER)
USHARE_SOURCE = uShare_v$(USHARE_VER).tar.gz
USHARE_URL    = https://github.com/GeeXboX/ushare/archive

$(ARCHIVE)/$(USHARE_SOURCE):
	$(DOWNLOAD) $(USHARE_URL)/$(USHARE_SOURCE)

$(D)/ushare: bootstrap libupnp $(ARCHIVE)/$(USHARE_SOURCE)
	$(REMOVE)/$(USHARE_DIR)
	$(UNTAR)/$(USHARE_SOURCE)
	$(CHDIR)/$(USHARE_DIR); \
		$(APPLY_PATCHES); \
		$(BUILD_ENV) \
		./configure \
			--prefix=/usr \
			--disable-dlna \
			--disable-nls \
			--cross-compile \
			--cross-prefix=$(TARGET_CROSS) \
			; \
		sed -i config.h -e 's@SYSCONFDIR.*@SYSCONFDIR "/etc"@'; \
		sed -i config.h -e 's@LOCALEDIR.*@LOCALEDIR "/share"@'; \
		ln -sf ../config.h src/; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(INSTALL_DATA) -D $(PKG_FILES_DIR)/ushare.conf $(TARGET_DIR)/etc/ushare.conf
	sed -i 's|%(BOXTYPE)|$(BOXTYPE)|; s|%(BOXMODEL)|$(BOXMODEL)|' $(TARGET_DIR)/etc/ushare.conf
	$(INSTALL_EXEC) -D $(PKG_FILES_DIR)/ushare.init $(TARGET_DIR)/etc/init.d/ushare
	$(UPDATE-RC.D) ushare defaults 75 25
	$(REMOVE)/$(USHARE_DIR)
	$(TOUCH)
