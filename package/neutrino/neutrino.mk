#
# makefile to build libstb-hal and neutrino
#
# -----------------------------------------------------------------------------

AUDIODEC = ffmpeg

NEUTRINO_DEPS  = bootstrap
NEUTRINO_DEPS += kernel
NEUTRINO_DEPS += system-tools
NEUTRINO_DEPS += ncurses
NEUTRINO_DEPS += libcurl
NEUTRINO_DEPS += libpng
NEUTRINO_DEPS += libjpeg-turbo
NEUTRINO_DEPS += giflib
NEUTRINO_DEPS += freetype
NEUTRINO_DEPS += alsa-utils
NEUTRINO_DEPS += ffmpeg
NEUTRINO_DEPS += libsigc
NEUTRINO_DEPS += libdvbsi
NEUTRINO_DEPS += libusb
NEUTRINO_DEPS += pugixml
NEUTRINO_DEPS += openthreads
NEUTRINO_DEPS += lua
NEUTRINO_DEPS += luaposix
NEUTRINO_DEPS += luaexpat
NEUTRINO_DEPS += luacurl
NEUTRINO_DEPS += luasocket
NEUTRINO_DEPS += lua-feedparser
NEUTRINO_DEPS += luasoap
NEUTRINO_DEPS += luajson
NEUTRINO_DEPS += wpa-supplicant
NEUTRINO_DEPS += wireless-tools
NEUTRINO_DEPS += ntfs-3g
NEUTRINO_DEPS += gptfdisk
NEUTRINO_DEPS += mc
NEUTRINO_DEPS += $(LOCAL_NEUTRINO_DEPS)
N_CONFIG_OPTS  = $(LOCAL_NEUTRINO_BUILD_OPTIONS)
ifeq ($(BOXMODEL), hd60)
NEUTRINO_DEPS += harfbuzz
endif
ifeq ($(EXTERNAL_LCD), graphlcd)
N_CONFIG_OPTS += --enable-graphlcd
NEUTRINO_DEPS += graphlcd-base
endif
ifeq ($(EXTERNAL_LCD), lcd4linux)
N_CONFIG_OPTS += --enable-lcd4linux
NEUTRINO_DEPS += lcd4linux
endif
ifeq ($(EXTERNAL_LCD), both)
N_CONFIG_OPTS += --enable-graphlcd
NEUTRINO_DEPS += graphlcd-base
N_CONFIG_OPTS += --enable-lcd4linux
NEUTRINO_DEPS += lcd4linux
endif
ifeq ($(AUDIODEC), ffmpeg)
# enable ffmpeg audio decoder in neutrino
N_CONFIG_OPTS += --enable-ffmpegdec
else
NEUTRINO_DEPS += libid3tag
NEUTRINO_DEPS += libmad

N_CONFIG_OPTS += --with-tremor
NEUTRINO_DEPS += libvorbisidec

N_CONFIG_OPTS += --enable-flac
NEUTRINO_DEPS += flac
endif
NEUTRINO_DEPS += neutrino-channellogos
NEUTRINO_DEPS += neutrino-mediathek
NEUTRINO_DEPS += neutrino-settings-updater
NEUTRINO_DEPS += neutrino-plugins
NEUTRINO_DEPS += xupnpd

# -----------------------------------------------------------------------------

OMDB_API_KEY ?=
ifneq ($(strip $(OMDB_API_KEY)),)
N_CONFIG_KEYS += \
	--with-omdb-api-key="$(OMDB_API_KEY)" \
	--disable-omdb-key-manage
endif

TMDB_DEV_KEY ?=
ifneq ($(strip $(TMDB_DEV_KEY)),)
N_CONFIG_KEYS += \
	--with-tmdb-dev-key="$(TMDB_DEV_KEY)" \
	--disable-tmdb-key-manage
endif

YOUTUBE_DEV_KEY ?=
ifneq ($(strip $(YOUTUBE_DEV_KEY)),)
N_CONFIG_KEYS += \
	--with-youtube-dev-key="$(YOUTUBE_DEV_KEY)" \
	--disable-youtube-key-manage
endif

SHOUTCAST_DEV_KEY ?=
ifneq ($(strip $(SHOUTCAST_DEV_KEY)),)
N_CONFIG_KEYS += \
	--with-shoutcast-dev-key="$(SHOUTCAST_DEV_KEY)" \
	--disable-shoutcast-key-manage
endif

WEATHER_DEV_KEY ?=
ifneq ($(strip $(WEATHER_DEV_KEY)),)
N_CONFIG_KEYS += \
	--with-weather-dev-key="$(WEATHER_DEV_KEY)" \
	--disable-weather-key-manage
endif

# -----------------------------------------------------------------------------

N_CONFIG_OPTS += \
	--with-libdir=/usr/lib \
	--with-datadir=/usr/share/tuxbox \
	--with-flagdir=/var/etc \
	--with-fontdir=/usr/share/fonts \
	--with-fontdir_var=/var/tuxbox/fonts \
	--with-configdir=/var/tuxbox/config \
	--with-gamesdir=/var/tuxbox/games \
	--with-iconsdir=/usr/share/tuxbox/neutrino/icons \
	--with-iconsdir_var=/var/tuxbox/icons \
	--with-localedir=/usr/share/tuxbox/neutrino/locale \
	--with-localedir_var=/var/tuxbox/locale \
	--with-plugindir=/usr/share/tuxbox/neutrino/plugins \
	--with-plugindir_var=/var/tuxbox/plugins \
	--with-luaplugindir=/usr/share/tuxbox/neutrino/luaplugins \
	--with-luaplugindir_var=/var/tuxbox/luaplugins \
	--with-private_httpddir=/usr/share/tuxbox/neutrino/httpd \
	--with-public_httpddir=/var/tuxbox/httpd \
	--with-themesdir=/usr/share/tuxbox/neutrino/themes \
	--with-themesdir_var=/var/tuxbox/themes \
	--with-webtvdir=/usr/share/tuxbox/neutrino/webtv \
	--with-webtvdir_var=/var/tuxbox/webtv \
	--with-webradiodir=/usr/share/tuxbox/neutrino/webradio \
	--with-webradiodir_var=/var/tuxbox/webradio \
	--with-controldir=/usr/share/tuxbox/neutrino/control \
	--with-controldir_var=/var/tuxbox/control

# -----------------------------------------------------------------------------

N_CFLAGS       = -Wall -W -Wshadow -pipe -Os -Wno-psabi
N_CFLAGS      += -D__STDC_FORMAT_MACROS
N_CFLAGS      += -D__STDC_CONSTANT_MACROS
N_CFLAGS      += -fno-strict-aliasing
N_CFLAGS      += -funsigned-char
N_CFLAGS      += -ffunction-sections
N_CFLAGS      += -fdata-sections
#N_CFLAGS      += -Wno-deprecated-declarations
N_CFLAGS      += $(LOCAL_NEUTRINO_CFLAGS)

N_CPPFLAGS     = -I$(TARGET_DIR)/usr/include
N_CPPFLAGS    += -ffunction-sections -fdata-sections

LH_CONFIG_OPTS =
#LH_CONFIG_OPTS += --enable-flv2mpeg4

# -----------------------------------------------------------------------------

N_OBJ_DIR = $(BUILD_DIR)/$(NEUTRINO)
LH_OBJ_DIR = $(BUILD_DIR)/$(LIBSTB_HAL)

ifeq ($(FLAVOUR), neutrino-max)
GIT_URL           ?= $(MAX-GIT-GITHUB)
NEUTRINO           = neutrino-max
LIBSTB_HAL         = libstb-hal-max
NEUTRINO_BRANCH   ?= master
LIBSTB_HAL_BRANCH ?= master
NEUTRINO_PATCH     =
LIBSTB_HAL_PATCH   =
else ifeq ($(FLAVOUR), neutrino-ni)
GIT_URL           ?= https://github.com/neutrino-images
NEUTRINO           = ni-neutrino
LIBSTB_HAL         = ni-libstb-hal
NEUTRINO_BRANCH   ?= master
LIBSTB_HAL_BRANCH ?= master
NEUTRINO_PATCH     =
LIBSTB_HAL_PATCH   =
else ifeq ($(FLAVOUR), neutrino-tangos)
GIT_URL           ?= https://github.com/TangoCash
NEUTRINO           = neutrino-tangos
LIBSTB_HAL         = libstb-hal-tangos
NEUTRINO_BRANCH   ?= master
LIBSTB_HAL_BRANCH ?= master
NEUTRINO_PATCH     =
LIBSTB_HAL_PATCH   =
else ifeq ($(FLAVOUR), neutrino-ddt)
GIT_URL           ?= https://github.com/Duckbox-Developers
NEUTRINO           = neutrino-ddt
LIBSTB_HAL         = libstb-hal-ddt
NEUTRINO_BRANCH   ?= master
LIBSTB_HAL_BRANCH ?= master
NEUTRINO_PATCH     =
LIBSTB_HAL_PATCH   =
endif

# -----------------------------------------------------------------------------

.version: $(TARGET_DIR)/.version
$(TARGET_DIR)/.version:
	echo "distro=$(subst neutrino-,,$(FLAVOUR))"				 > $@
	echo "imagename=Neutrino MP"						>> $@
	echo "imageversion=`sed -n 's/\#define PACKAGE_VERSION "//p' $(N_OBJ_DIR)/config.h | sed 's/"//'`" >> $@
	echo "homepage=https://github.com/Duckbox-Developers"			>> $@
	echo "creator=$(MAINTAINER)"						>> $@
	echo "docs=https://github.com/Duckbox-Developers"			>> $@
	echo "forum=https://github.com/Duckbox-Developers/neutrino-mp-ddt"	>> $@
	echo "version=0200`date +%Y%m%d%H%M`"					>> $@
	echo "builddate="`date`							>> $@
	echo "git=BS-rev$(BS_REV)_HAL-rev$(HAL_REV)_NMP-rev$(NMP_REV)"		>> $@
	echo "imagedir=$(BOXMODEL)"						>> $@

# -----------------------------------------------------------------------------

e2-multiboot:
	touch $(TARGET_DIR)/usr/bin/enigma2
	#
	echo -e "$(FLAVOUR) `sed -n 's/\#define PACKAGE_VERSION "//p' $(N_OBJ_DIR)/config.h | sed 's/"//'` \\\n \\\l\n" > $(TARGET_DIR)/etc/issue
	#
	touch $(TARGET_DIR)/var/lib/opkg/status
	#
	cp -a $(TARGET_DIR)/.version $(TARGET_DIR)/etc/image-version

# -----------------------------------------------------------------------------

version.h: $(SOURCE_DIR)/$(NEUTRINO)/src/gui/version.h
$(SOURCE_DIR)/$(NEUTRINO)/src/gui/version.h:
	@rm -f $@
	echo '#define BUILT_DATE "'`date`'"' > $@
	@if test -d $(SOURCE_DIR)/$(LIBSTB_HAL); then \
		echo '#define VCS "BS-rev$(BS_REV)_HAL-rev$(HAL_REV)_NMP-rev$(NMP_REV)"' >> $@; \
	fi

# -----------------------------------------------------------------------------

LIBSTB_HAL_DEPS  = bootstrap
LIBSTB_HAL_DEPS += ffmpeg
LIBSTB_HAL_DEPS += openthreads

LIBSTB_HAL_VER    = git
LIBSTB_HAL_DIR    = $(LIBSTB_HAL).$(LIBSTB_HAL_VER)
LIBSTB_HAL_SOURCE = $(LIBSTB_HAL_DIR)

$(D)/libstb-hal.do_prepare: | $(LIBSTB_HAL_DEPS)
	$(START_BUILD)
	rm -rf $(SOURCE_DIR)/$(LIBSTB_HAL)
	rm -rf $(SOURCE_DIR)/$(LIBSTB_HAL).org
	rm -rf $(LH_OBJ_DIR)
	test -d $(SOURCE_DIR) || mkdir -p $(SOURCE_DIR)
	$(GET-GIT-SOURCE) $(GIT_URL)/$(LIBSTB_HAL_SOURCE) $(ARCHIVE)/$(LIBSTB_HAL_SOURCE)
	cp -ra $(ARCHIVE)/$(LIBSTB_HAL_SOURCE) $(SOURCE_DIR)/$(LIBSTB_HAL)
	(cd $(SOURCE_DIR)/$(LIBSTB_HAL); git checkout -q $(LIBSTB_HAL_BRANCH);)
	cp -ra $(SOURCE_DIR)/$(LIBSTB_HAL) $(SOURCE_DIR)/$(LIBSTB_HAL).org
	$(CD) $(SOURCE_DIR)/$(LIBSTB_HAL); \
		$(call apply_patches, $(LIBSTB_HAL_PATCH))
	@touch $@

$(D)/libstb-hal.config.status:
	rm -rf $(LH_OBJ_DIR)
	test -d $(LH_OBJ_DIR) || mkdir -p $(LH_OBJ_DIR)
	cd $(LH_OBJ_DIR); \
		$(SOURCE_DIR)/$(LIBSTB_HAL)/autogen.sh $(SILENT_OPT); \
		$(BUILD_ENV) \
		$(SOURCE_DIR)/$(LIBSTB_HAL)/configure $(SILENT_OPT) \
			--host=$(TARGET) \
			--build=$(BUILD) \
			--prefix=/usr \
			--enable-maintainer-mode \
			--enable-silent-rules \
			--enable-shared=no \
			\
			--with-target=cdk \
			--with-targetprefix=/usr \
			--with-boxtype=$(BOXTYPE) \
			--with-boxmodel=$(BOXMODEL) \
			$(LH_CONFIG_OPTS) \
			CFLAGS="$(N_CFLAGS)" CXXFLAGS="$(N_CFLAGS) -std=c++11" CPPFLAGS="$(N_CPPFLAGS)"
ifeq ($(TINKER_OPTION), 0)
	@touch $@
endif

$(D)/libstb-hal.do_compile: libstb-hal.config.status
	$(MAKE) -C $(LH_OBJ_DIR) DESTDIR=$(TARGET_DIR)
	@touch $@

$(D)/libstb-hal: libstb-hal.do_prepare libstb-hal.do_compile
	$(MAKE) -C $(LH_OBJ_DIR) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libstb-hal.la
	$(TOUCH)

# -----------------------------------------------------------------------------

libstb-hal-clean:
	rm -f $(D)/libstb-hal
	rm -f $(D)/libstb-hal.config.status
	rm -f $(D)/neutrino.config.status
	cd $(LH_OBJ_DIR); \
		$(MAKE) -C $(LH_OBJ_DIR) distclean

libstb-hal-distclean:
	rm -rf $(LH_OBJ_DIR)
	rm -f $(D)/libstb-hal*
	rm -f $(D)/neutrino.config.status

libstb-hal-uninstall:
	-make -C $(LH_OBJ_DIR) uninstall DESTDIR=$(TARGET_DIR)

# -----------------------------------------------------------------------------

NEUTRINO_VER    = git
NEUTRINO_DIR    = $(NEUTRINO).$(NEUTRINO_VER)
NEUTRINO_SOURCE = $(NEUTRINO_DIR)

$(D)/neutrino.do_prepare: | $(NEUTRINO_DEPS) libstb-hal
	$(START_BUILD)
	rm -rf $(SOURCE_DIR)/$(NEUTRINO)
	rm -rf $(SOURCE_DIR)/$(NEUTRINO).org
	rm -rf $(N_OBJ_DIR)
	$(GET-GIT-SOURCE) $(GIT_URL)/$(NEUTRINO_SOURCE) $(ARCHIVE)/$(NEUTRINO_SOURCE)
	cp -ra $(ARCHIVE)/$(NEUTRINO_SOURCE) $(SOURCE_DIR)/$(NEUTRINO)
	(cd $(SOURCE_DIR)/$(NEUTRINO); git checkout -q $(NEUTRINO_BRANCH);)
	cp -ra $(SOURCE_DIR)/$(NEUTRINO) $(SOURCE_DIR)/$(NEUTRINO).org
	$(CD) $(SOURCE_DIR)/$(NEUTRINO); \
		$(call apply_patches, $(NEUTRINO_PATCH))
	@touch $@

$(D)/neutrino.config.status:
	rm -rf $(N_OBJ_DIR)
	test -d $(N_OBJ_DIR) || mkdir -p $(N_OBJ_DIR)
	cd $(N_OBJ_DIR); \
		$(SOURCE_DIR)/$(NEUTRINO)/autogen.sh $(SILENT_OPT); \
		$(BUILD_ENV) \
		$(SOURCE_DIR)/$(NEUTRINO)/configure $(SILENT_OPT) \
			--host=$(TARGET) \
			--build=$(BUILD) \
			--prefix=/usr \
			--enable-maintainer-mode \
			--enable-silent-rules \
			\
			--enable-freesatepg \
			--enable-fribidi \
			--enable-giflib \
			--enable-lua \
			--enable-pugixml \
			--enable-reschange \
			\
			$(N_CONFIG_KEYS) \
			\
			$(N_CONFIG_OPTS) \
			\
			--with-tremor \
			--with-boxtype=$(BOXTYPE) \
			--with-boxmodel=$(BOXMODEL) \
			--with-stb-hal-includes=$(SOURCE_DIR)/$(LIBSTB_HAL)/include \
			--with-stb-hal-build=$(LH_OBJ_DIR) \
			CFLAGS="$(N_CFLAGS)" CXXFLAGS="$(N_CFLAGS) -std=c++11" CPPFLAGS="$(N_CPPFLAGS)"
		+make $(SOURCE_DIR)/$(NEUTRINO)/src/gui/version.h
ifeq ($(TINKER_OPTION), 0)
	@touch $@
endif

$(D)/neutrino.do_compile:
	$(MAKE) -C $(N_OBJ_DIR) all DESTDIR=$(TARGET_DIR)
	@touch $@

mp: neutrino
$(D)/neutrino: neutrino.do_prepare neutrino.config.status neutrino.do_compile
	$(MAKE) -C $(N_OBJ_DIR) install DESTDIR=$(TARGET_DIR)
	make .version
	make e2-multiboot
ifeq ($(FLAVOUR), $(filter $(FLAVOUR), neutrino-max neutrino-ni))
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/start_neutrino1 $(TARGET_DIR)/etc/init.d/start_neutrino
else
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/start_neutrino2 $(TARGET_DIR)/etc/init.d/start_neutrino
endif
	$(TOUCH)
	make neutrino-release
	$(TUXBOX_CUSTOMIZE)

# -----------------------------------------------------------------------------

mp-clean \
neutrino-clean:
	rm -f $(D)/neutrino
	rm -f $(D)/neutrino.config.status
	rm -f $(SOURCE_DIR)/$(NEUTRINO)/src/gui/version.h
	cd $(N_OBJ_DIR); \
		$(MAKE) -C $(N_OBJ_DIR) distclean

mp-distclean \
neutrino-distclean:
	rm -rf $(N_OBJ_DIR)
	rm -f $(D)/neutrino
	rm -f $(D)/neutrino.config.status
	rm -f $(D)/neutrino.do_compile
	rm -f $(D)/neutrino.do_prepare

neutrino-uninstall:
	-make -C $(N_OBJ_DIR) uninstall DESTDIR=$(TARGET_DIR)

# -----------------------------------------------------------------------------

PHONY += $(TARGET_DIR)/.version
PHONY += $(SOURCE_DIR)/$(NEUTRINO)/src/gui/version.h
