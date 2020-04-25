#
# dbus
#
DBUS_VER    = 1.12.6
DBUS_DIR    = dbus-$(DBUS_VER)
DBUS_SOURCE = dbus-$(DBUS_VER).tar.gz
DBUS_URL    = https://dbus.freedesktop.org/releases/dbus

$(ARCHIVE)/$(DBUS_SOURCE):
	$(DOWNLOAD) $(DBUS_URL)/$(DBUS_SOURCE)

$(D)/dbus: bootstrap expat $(ARCHIVE)/$(DBUS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(DBUS_DIR)
	$(UNTAR)/$(DBUS_SOURCE)
	$(CHDIR)/$(DBUS_DIR); \
		$(CONFIGURE) \
		CFLAGS="$(TARGET_CFLAGS) -Wno-cast-align" \
			--without-x \
			--prefix=/usr \
			--docdir=/.remove \
			--sysconfdir=/etc \
			--localstatedir=/var \
			--with-console-auth-dir=/var/run/console/ \
			--without-systemdsystemunitdir \
			--disable-systemd \
			--disable-static \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libdbus-1.la
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,dbus-cleanup-sockets dbus-daemon dbus-launch dbus-monitor)
	$(REMOVE)/$(DBUS_DIR)
	$(TOUCH)
