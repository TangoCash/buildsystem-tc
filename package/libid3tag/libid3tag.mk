#
# libid3tag
#
LIBID3TAG_VER    = 0.15.1b
LIBID3TAG_DIR    = libid3tag-$(LIBID3TAG_VER)
LIBID3TAG_SOURCE = libid3tag-$(LIBID3TAG_VER).tar.gz
LIBID3TAG_URL    = https://sourceforge.net/projects/mad/files/libid3tag/$(LIBID3TAG_VER)

$(ARCHIVE)/$(LIBID3TAG_SOURCE):
	$(DOWNLOAD) $(LIBID3TAG_URL)/$(LIBID3TAG_SOURCE)

LIBID3TAG_PATCH  = \
	0001-libid3tag-pc.patch

$(D)/libid3tag: bootstrap zlib $(ARCHIVE)/$(LIBID3TAG_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBID3TAG_DIR)
	$(UNTAR)/$(LIBID3TAG_SOURCE)
	$(CHDIR)/$(LIBID3TAG_DIR); \
		$(call apply_patches, $(LIBID3TAG_PATCH)); \
		touch NEWS AUTHORS ChangeLog; \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--enable-shared=yes \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libid3tag.la
	$(REMOVE)/$(LIBID3TAG_DIR)
	$(TOUCH)
