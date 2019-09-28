#
# libevent
#
LIBEVENT_VER    = 2.0.21-stable
LIBEVENT_DIR    = libevent-$(LIBEVENT_VER)
LIBEVENT_SOURCE = libevent-$(LIBEVENT_VER).tar.gz
LIBEVENT_URL    = https://github.com/downloads/libevent/libevent

$(ARCHIVE)/$(LIBEVENT_SOURCE):
	$(DOWNLOAD) $(LIBEVENT_URL)/$(LIBEVENT_SOURCE)

$(D)/libevent: bootstrap $(ARCHIVE)/$(LIBEVENT_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBEVENT_DIR)
	$(UNTAR)/$(LIBEVENT_SOURCE)
	$(CHDIR)/$(LIBEVENT_DIR);\
		$(CONFIGURE) \
			--prefix=/usr \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libevent_core.la
	$(REWRITE_LIBTOOL)/libevent_extra.la
	$(REWRITE_LIBTOOL)/libevent.la
	$(REWRITE_LIBTOOL)/libevent_openssl.la
	$(REWRITE_LIBTOOL)/libevent_pthreads.la
	$(REMOVE)/$(LIBEVENT_DIR)
	$(TOUCH)
