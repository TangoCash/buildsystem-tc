#
# bzip2
#
BZIP2_VER    = 1.0.8
BZIP2_DIR    = bzip2-$(BZIP2_VER)
BZIP2_SOURCE = bzip2-$(BZIP2_VER).tar.gz
BZIP2_URL    = https://sourceware.org/pub/bzip2

$(ARCHIVE)/$(BZIP2_SOURCE):
	$(DOWNLOAD) $(BZIP2_URL)/$(BZIP2_SOURCE)

BZIP2_PATCH  = \
	0001-bzip2.patch

$(D)/bzip2: bootstrap $(ARCHIVE)/$(BZIP2_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(BZIP2_DIR)
	$(UNTAR)/$(BZIP2_SOURCE)
	$(CHDIR)/$(BZIP2_DIR); \
		$(call apply_patches, $(BZIP2_PATCH)); \
		mv Makefile-libbz2_so Makefile; \
		$(MAKE) all CC=$(TARGET_CC) AR=$(TARGET_AR) RANLIB=$(TARGET_RANLIB); \
		$(MAKE) install PREFIX=$(TARGET_DIR)/usr
	$(REMOVE)/$(BZIP2_DIR)
	$(TOUCH)
