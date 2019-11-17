#
# alsa-utils
#
ALSA_UTILS_VER    = 1.2.1
ALSA_UTILS_DIR    = alsa-utils-$(ALSA_UTILS_VER)
ALSA_UTILS_SOURCE = alsa-utils-$(ALSA_UTILS_VER).tar.bz2
ALSA_UTILS_URL    = https://www.alsa-project.org/files/pub/utils

$(ARCHIVE)/$(ALSA_UTILS_SOURCE):
	$(DOWNLOAD) $(ALSA_UTILS_URL)/$(ALSA_UTILS_SOURCE)

ALSA_UTILS_PATCH  = \
	alsa-utils.patch

$(D)/alsa-utils: bootstrap ncurses alsa-lib $(ARCHIVE)/$(ALSA_UTILS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(ALSA_UTILS_DIR)
	$(UNTAR)/$(ALSA_UTILS_SOURCE)
	$(CHDIR)/$(ALSA_UTILS_DIR); \
		$(call apply_patches, $(ALSA_UTILS_PATCH)); \
		sed -ir -r "s/(amidi|aplay|iecset|speaker-test|seq|alsaucm|topology)//g" Makefile.am ;\
		autoreconf -fi -I $(TARGET_DIR)/usr/share/aclocal $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--with-curses=ncurses \
			--enable-silent-rules \
			--with-udev-rules-dir=/.remove \
			--disable-bat \
			--disable-nls \
			--disable-alsatest \
			--disable-alsaconf \
			--disable-alsaloop \
			--disable-xmlto \
			--disable-rst2man \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(INSTALL_DATA) $(PKG_FILES_DIR)/asound.conf $(TARGET_DIR)/etc/asound.conf
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/alsa-state.init $(TARGET_DIR)/etc/init.d/alsa-state
	$(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR) alsa-state start 39 S . stop 31 0 6 .
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,aserver)
	rm -f $(addprefix $(TARGET_DIR)/usr/sbin/,alsa-info.sh)
#	$(REMOVE)/$(ALSA_UTILS_DIR)
	$(TOUCH)
