#
# avahi
#
AVAHI_VER    = 0.7
AVAHI_DIR    = avahi-$(AVAHI_VER)
AVAHI_SOURCE = avahi-$(AVAHI_VER).tar.gz
AVAHI_URL    = https://github.com/lathiat/avahi/releases/download/v$(AVAHI_VER)

$(ARCHIVE)/$(AVAHI_SOURCE):
	$(DOWNLOAD) $(AVAHI_URL)/$(AVAHI_SOURCE)

$(D)/avahi: bootstrap expat libdaemon dbus $(ARCHIVE)/$(AVAHI_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(AVAHI_DIR)
	$(UNTAR)/$(AVAHI_SOURCE)
	$(CHDIR)/$(AVAHI_DIR); \
		$(CONFIGURE) \
			--target=$(TARGET) \
			--prefix=/usr \
			--mandir=/.remove \
			--localedir=/.remove/locale \
			--sysconfdir=/etc \
			--localstatedir=/var \
			--with-distro=none \
			--with-avahi-user=nobody \
			--with-avahi-group=nogroup \
			--with-autoipd-user=nobody \
			--with-autoipd-group=nogroup \
			--with-xml=expat \
			--enable-libdaemon \
			--disable-nls \
			--disable-glib \
			--disable-gobject \
			--disable-qt3 \
			--disable-qt4 \
			--disable-gtk \
			--disable-gtk3 \
			--disable-dbm \
			--disable-gdbm \
			--disable-python \
			--disable-python-dbus \
			--disable-mono \
			--disable-monodoc \
			--disable-autoipd \
			--disable-doxygen-doc \
			--disable-doxygen-dot \
			--disable-doxygen-man \
			--disable-doxygen-rtf \
			--disable-doxygen-xml \
			--disable-doxygen-chm \
			--disable-doxygen-chi \
			--disable-doxygen-html \
			--disable-doxygen-ps \
			--disable-doxygen-pdf \
			--disable-core-docs \
			--disable-manpages \
			--disable-xmltoman \
			--disable-tests \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	cp $(BUILD_DIR)/$(AVAHI_DIR)/avahi-daemon/avahi-daemon $(TARGET_DIR)/etc/init.d
	$(REWRITE_LIBTOOL)/libavahi-common.la
	$(REWRITE_LIBTOOL)/libavahi-core.la
	$(REWRITE_LIBTOOL)/libavahi-client.la
	$(REMOVE)/$(AVAHI_DIR)
	$(TOUCH)
