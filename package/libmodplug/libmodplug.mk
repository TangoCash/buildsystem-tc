#
# libmodplug
#
LIBMODPLUG_VER    = 0.8.8.4
LIBMODPLUG_DIR    = libmodplug-$(LIBMODPLUG_VER)
LIBMODPLUG_SOURCE = libmodplug-$(LIBMODPLUG_VER).tar.gz
LIBMODPLUG_URL    = https://sourceforge.net/projects/modplug-xmms/files/libmodplug/$(LIBMODPLUG_VER)

$(ARCHIVE)/$(LIBMODPLUG_SOURCE):
	$(DOWNLOAD) $(LIBMODPLUG_URL)/$(LIBMODPLUG_SOURCE)

$(D)/libmodplug: bootstrap $(ARCHIVE)/$(LIBMODPLUG_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBMODPLUG_DIR)
	$(UNTAR)/$(LIBMODPLUG_SOURCE)
	$(CHDIR)/$(LIBMODPLUG_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libmodplug.la
	$(REMOVE)/$(LIBMODPLUG_DIR)
	$(TOUCH)
