#
# libdvbsi
#
LIBDVBSI_VER    = git
LIBDVBSI_DIR    = libdvbsi.$(LIBDVBSI_VER)
LIBDVBSI_SOURCE = $(LIBDVBSI_DIR)
LIBDVBSI_URL    = https://github.com/OpenVisionE2/libdvbsi.git

LIBDVBSI_PATCH  = \
	content_identifier_descriptor.patch

$(D)/libdvbsi: bootstrap
	$(START_BUILD)
	$(REMOVE)/$(LIBDVBSI_DIR)
	$(GET-GIT-SOURCE) $(LIBDVBSI_URL) $(ARCHIVE)/$(LIBDVBSI_SOURCE)
	$(CPDIR)/$(LIBDVBSI_DIR)
	$(CHDIR)/$(LIBDVBSI_DIR); \
		$(call apply_patches, $(LIBDVBSI_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libdvbsi++.la
	$(REMOVE)/$(LIBDVBSI_DIR)
	$(TOUCH)
