#
# neutrino-plugins
#
NEUTRINO_PLUGINS_VER     = git
NEUTRINO_PLUGINS_DIR     = neutrino-plugins.$(NEUTRINO_PLUGINS_VER)
NEUTRINO_PLUGINS_SOURCE  = $(NEUTRINO_PLUGINS_DIR)
NEUTRINO_PLUGINS_URL     = $(MAX-GIT-GITHUB)/neutrino-plugins.git
NEUTRINO_PLUGINS_OBJ_DIR = $(BUILD_DIR)/neutrino-plugins

NP_CONFIGURE_ADDITIONS = \
	$(LOCAL_N_PLUGIN_BUILD_OPTIONS)

NP_CONFIGURE_ADDITIONS += \
	--disable-add-locale \
	--disable-coolitsclimax \
	--disable-logoupdater \
	--disable-logoview \
	--disable-mountpointmanagement \
	--disable-oscammon \
	--disable-stbup \
	--disable-vinfo

ifeq ($(BOXMODEL), $(filter $(BOXMODEL), vuduo4k vusolo4k vuultimo4k vuuno4k vuuno4kse vuzero4k))
NP_CONFIGURE_ADDITIONS += \
	--enable-stb_startup_vuplus
endif

$(D)/neutrino-plugins.do_prepare: | bootstrap ffmpeg libcurl libpng libjpeg-turbo giflib freetype
	$(START_BUILD)
	rm -rf $(SOURCE_DIR)/$(NEUTRINO_PLUGINS_DIR)
	$(GET-GIT-SOURCE) $(NEUTRINO_PLUGINS_URL) $(ARCHIVE)/$(NEUTRINO_PLUGINS_SOURCE)
	cp -ra $(ARCHIVE)/$(NEUTRINO_PLUGINS_DIR) $(SOURCE_DIR)/$(NEUTRINO_PLUGINS_DIR)
	@touch $@

$(D)/neutrino-plugins.config.status:
	rm -rf $(NEUTRINO_PLUGINS_OBJ_DIR)
	test -d $(NEUTRINO_PLUGINS_OBJ_DIR) || mkdir -p $(NEUTRINO_PLUGINS_OBJ_DIR)
	cd $(NEUTRINO_PLUGINS_OBJ_DIR); \
		$(SOURCE_DIR)/$(NEUTRINO_PLUGINS_DIR)/autogen.sh $(SILENT_OPT) && automake --add-missing $(SILENT_OPT); \
		$(BUILD_ENV) \
		$(SOURCE_DIR)/$(NEUTRINO_PLUGINS_DIR)/configure $(SILENT_OPT) \
			--host=$(TARGET) \
			--build=$(BUILD) \
			--prefix=/usr \
			--enable-maintainer-mode \
			--enable-silent-rules \
			\
			$(NP_CONFIGURE_ADDITIONS) \
			\
			--with-target=cdk \
			--include=/usr/include \
			--with-targetprefix=/usr \
			--with-boxtype=$(BOXTYPE) \
			--with-boxmodel=$(BOXMODEL) \
			CXXFLAGS="$(N_CFLAGS) -std=c++11" CPPFLAGS="$(N_CPPFLAGS) -DNEW_LIBCURL" \
			LDFLAGS="$(TARGET_LDFLAGS)"
	@touch $@

$(D)/neutrino-plugins.do_compile: neutrino-plugins.config.status
	$(MAKE) -C $(NEUTRINO_PLUGINS_OBJ_DIR) DESTDIR=$(TARGET_DIR)
	@touch $@

$(D)/neutrino-plugins: neutrino-plugins.do_prepare neutrino-plugins.do_compile
	mkdir -p $(TARGET_DIR)/usr/share/tuxbox/neutrino/icons
	$(MAKE) -C $(NEUTRINO_PLUGINS_OBJ_DIR) install DESTDIR=$(TARGET_DIR)
	rm -rf $(addprefix $(TARGET_DIR)/etc/init.d/,K01* S99*)
	$(TOUCH)

neutrino-plugins-clean:
	rm -f $(D)/neutrino-plugins
	rm -f $(D)/neutrino-plugins.config.status
	rm -f $(D)/neutrino.config.status
	cd $(NEUTRINO_PLUGINS_OBJ_DIR); \
		$(MAKE) -C $(NEUTRINO_PLUGINS_OBJ_DIR) clean

neutrino-plugins-distclean:
	rm -rf $(NEUTRINO_PLUGINS_OBJ_DIR)
	rm -f $(D)/neutrino-plugin*
	rm -f $(D)/neutrino.config.status
