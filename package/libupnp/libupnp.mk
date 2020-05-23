LIBUPNP_VER    = 1.6.25
LIBUPNP_DIR    = libupnp-$(LIBUPNP_VER)
LIBUPNP_SOURCE = libupnp-$(LIBUPNP_VER).tar.bz2
LIBUPNP_URL    = http://sourceforge.net/projects/pupnp/files/pupnp/libUPnP%20$(LIBUPNP_VER)

$(ARCHIVE)/$(LIBUPNP_SOURCE):
	$(DOWNLOAD) $(LIBUPNP_URL)/$(LIBUPNP_SOURCE)

$(D)/libupnp: bootstrap $(ARCHIVE)/$(LIBUPNP_SOURCE)
	$(REMOVE)/$(LIBUPNP_DIR)
	$(UNTAR)/$(LIBUPNP_SOURCE)
	$(CHDIR)/$(LIBUPNP_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--enable-shared \
			--disable-static \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libixml.la
	$(REWRITE_LIBTOOL)/libthreadutil.la
	$(REWRITE_LIBTOOL)/libupnp.la
	$(REMOVE)/$(LIBUPNP_DIR)
	$(TOUCH)
