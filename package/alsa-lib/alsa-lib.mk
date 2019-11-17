#
# alsa-lib
#
ALSA_LIB_VER    = 1.2.1
ALSA_LIB_DIR    = alsa-lib-$(ALSA_LIB_VER)
ALSA_LIB_SOURCE = alsa-lib-$(ALSA_LIB_VER).tar.bz2
ALSA_LIB_URL    = https://www.alsa-project.org/files/pub/lib

$(ARCHIVE)/$(ALSA_LIB_SOURCE):
	$(DOWNLOAD) $(ALSA_LIB_URL)/$(ALSA_LIB_SOURCE)

ALSA_LIB_PATCH  = \
	alsa-lib.patch \
	alsa-lib-link_fix.patch

$(D)/alsa-lib: bootstrap $(ARCHIVE)/$(ALSA_LIB_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(ALSA_LIB_DIR)
	$(UNTAR)/$(ALSA_LIB_SOURCE)
	$(CHDIR)/$(ALSA_LIB_DIR); \
		$(call apply_patches, $(ALSA_LIB_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			--with-alsa-devdir=/dev/snd/ \
			--with-plugindir=/usr/lib/alsa \
			--without-debug \
			--with-debug=no \
			--with-versioned=no \
			--enable-symbolic-functions \
			--enable-silent-rules \
			--disable-aload \
			--disable-rawmidi \
			--disable-resmgr \
			--disable-old-symbols \
			--disable-alisp \
			--disable-hwdep \
			--disable-python \
			--disable-topology \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libasound.la
	$(REMOVE)/$(ALSA_LIB_DIR)
	$(TOUCH)
