#
# libdaemon
#
LIBDAEMON_VER    = 0.14
LIBDAEMON_DIR    = libdaemon-$(LIBDAEMON_VER)
LIBDAEMON_SOURCE = libdaemon-$(LIBDAEMON_VER).tar.gz
LIBDAEMON_URL    = http://0pointer.de/lennart/projects/libdaemon

$(ARCHIVE)/$(LIBDAEMON_SOURCE):
	$(DOWNLOAD) $(LIBDAEMON_URL)/$(LIBDAEMON_SOURCE)

$(D)/libdaemon: bootstrap $(ARCHIVE)/$(LIBDAEMON_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBDAEMON_DIR)
	$(UNTAR)/$(LIBDAEMON_SOURCE)
	$(CHDIR)/$(LIBDAEMON_DIR); \
		$(CONFIGURE) \
			ac_cv_func_setpgrp_void=yes \
			--prefix=/usr \
			--docdir=/.remove \
			--disable-static \
			--disable-lynx \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libdaemon.la
	$(REMOVE)/$(LIBDAEMON_DIR)
	$(TOUCH)
