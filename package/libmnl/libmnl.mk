#
# libmnl
#
LIBMNL_VER    = 1.0.4
LIBMNL_DIR    = libmnl-$(LIBMNL_VER)
LIBMNL_SOURCE = libmnl-$(LIBMNL_VER).tar.bz2
LIBMNL_URL    = http://netfilter.org/projects/libmnl/files

$(ARCHIVE)/$(LIBMNL_SOURCE):
	$(DOWNLOAD) $(LIBMNL_URL)/$(LIBMNL_SOURCE)

$(D)/libmnl: bootstrap $(ARCHIVE)/$(LIBMNL_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBMNL_DIR)
	$(UNTAR)/$(LIBMNL_SOURCE)
	$(CHDIR)/$(LIBMNL_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
		; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libmnl.la
	$(REMOVE)/$(LIBMNL_DIR)
	$(TOUCH)
