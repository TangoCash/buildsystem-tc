#
# howl
#
HOWL_VER    = 1.0.0
HOWL_DIR    = howl-$(HOWL_VER)
HOWL_SOURCE = howl-$(HOWL_VER).tar.gz
HOWL_URL    = https://sourceforge.net/projects/howl/files/howl/$(HOWL_VER)

$(ARCHIVE)/$(HOWL_SOURCE):
	$(DOWNLOAD) $(HOWL_URL)/$(HOWL_SOURCE)

HOWL_PATCH  = \
	0001-ipv4-mapped-ipv6.patch

$(D)/howl: bootstrap $(ARCHIVE)/$(HOWL_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HOWL_DIR)
	$(UNTAR)/$(HOWL_SOURCE)
	$(CHDIR)/$(HOWL_DIR); \
		$(call apply_patches, $(HOWL_PATCH)); \
		$(CONFIGURE) \
			--target=$(TARGET) \
			--prefix=/usr \
			--mandir=/.remove \
			--datadir=/.remove \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libhowl.la
	$(REWRITE_LIBTOOL)/libmDNSResponder.la
	$(REMOVE)/$(HOWL_DIR)
	$(TOUCH)
