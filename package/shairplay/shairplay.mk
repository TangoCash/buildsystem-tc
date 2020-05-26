#
# shairplay
#
SHAIRPLAY_VER      = git
SHAIRPLAY_DIR      = shairplay.$(SHAIRPLAY_VER)
SHAIRPLAY_SOURCE   = shairplay.$(SHAIRPLAY_VER)
SHAIRPLAY_URL      = https://github.com/juhovh
SHAIRPLAY_CHECKOUT = 193138f3

SHAIRPLAY_PATCH  = \
	0001-shairplay-howl.patch

$(D)/shairplay: bootstrap libao howl
	$(START_BUILD)
	$(REMOVE)/$(SHAIRPLAY_DIR)
	$(GET-GIT-SOURCE) $(SHAIRPLAY_URL)/$(SHAIRPLAY_SOURCE) $(ARCHIVE)/$(SHAIRPLAY_SOURCE)
	$(CPDIR)/$(SHAIRPLAY_DIR)
	$(CHDIR)/$(SHAIRPLAY_DIR); git checkout -q $(SHAIRPLAY_CHECKOUT); \
	$(CHDIR)/$(SHAIRPLAY_DIR); \
		$(call apply_patches, $(SHAIRPLAY_PATCH)); \
		for A in src/test/example.c src/test/main.c src/shairplay.c ; do sed -i "s#airport.key#/usr/share/shairplay/airport.key#" $$A ; done && \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--enable-shared \
			--disable-static \
			--prefix=/usr \
			; \
		$(MAKE) install DESTDIR=$(TARGET_DIR); \
		mkdir -p $(TARGET_SHARE_DIR)/shairplay; \
		$(INSTALL_DATA) airport.key $(TARGET_SHARE_DIR)/shairplay; \
	$(REWRITE_LIBTOOL)/libshairplay.la
	$(REMOVE)/$(SHAIRPLAY_DIR)
	$(TOUCH)
