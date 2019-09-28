#
# libnfsidmap
#
LIBNFSIDMAP_VER    = 0.25
LIBNFSIDMAP_DIR    = libnfsidmap-$(LIBNFSIDMAP_VER)
LIBNFSIDMAP_SOURCE = libnfsidmap-$(LIBNFSIDMAP_VER).tar.gz
LIBNFSIDMAP_URL    = http://www.citi.umich.edu/projects/nfsv4/linux/libnfsidmap

$(ARCHIVE)/$(LIBNFSIDMAP_SOURCE):
	$(DOWNLOAD) $(LIBNFSIDMAP_URL)/$(LIBNFSIDMAP_SOURCE)

$(D)/libnfsidmap: bootstrap $(ARCHIVE)/$(LIBNFSIDMAP_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBNFSIDMAP_DIR)
	$(UNTAR)/$(LIBNFSIDMAP_SOURCE)
	$(CHDIR)/$(LIBNFSIDMAP_DIR);\
		$(CONFIGURE) \
		ac_cv_func_malloc_0_nonnull=yes \
			--prefix=/usr \
			--mandir=/.remove \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libnfsidmap.la
	$(REMOVE)/$(LIBNFSIDMAP_DIR)
	$(TOUCH)
