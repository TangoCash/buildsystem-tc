#
# astra-sm
#
ASTRA_SM_VER    = git
ASTRA_SM_DIR    = astra-sm.$(ASTRA_SM_VER)
ASTRA_SM_SOURCE = astra-sm.$(ASTRA_SM_VER)
ASTRA_SM_URL    = https://gitlab.com/crazycat69

ASTRA_SM_PATCH  = \
	0001-astra-sm.patch

$(D)/astra-sm: bootstrap openssl
	$(START_BUILD)
	$(REMOVE)/$(ASTRA_SM_DIR)
	$(GET-GIT-SOURCE) $(ASTRA_SM_URL)/$(ASTRA_SM_SOURCE) $(ARCHIVE)/$(ASTRA_SM_SOURCE)
	$(CPDIR)/$(ASTRA_SM_DIR)
	$(CHDIR)/$(ASTRA_SM_DIR); \
		$(call apply_patches, $(ASTRA_SM_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		sed -i 's:(CFLAGS):(CFLAGS_FOR_BUILD):' tools/Makefile.am; \
		$(CONFIGURE) \
			--prefix=/usr \
			--sysconfdir=/etc \
			--without-lua \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(ASTRA_SM_DIR)
	$(TOUCH)
