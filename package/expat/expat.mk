#
# expat
#
EXPAT_VER    = 2.2.9
EXPAT_DIR    = expat-$(EXPAT_VER)
EXPAT_SOURCE = expat-$(EXPAT_VER).tar.bz2
EXPAT_URL    = https://sourceforge.net/projects/expat/files/expat/$(EXPAT_VER)

$(ARCHIVE)/$(EXPAT_SOURCE):
	$(DOWNLOAD) $(EXPAT_URL)/$(EXPAT_SOURCE)

EXPAT_PATCH  = \
	libtool-tag.patch

$(D)/expat: bootstrap $(ARCHIVE)/$(EXPAT_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(EXPAT_DIR)
	$(UNTAR)/$(EXPAT_SOURCE)
	$(CHDIR)/$(EXPAT_DIR); \
		$(call apply_patches, $(EXPAT_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--bindir=/.remove \
			--docdir=/.remove \
			--without-xmlwf \
			--without-docbook \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libexpat.la
	$(REMOVE)/$(EXPAT_DIR)
	$(TOUCH)
