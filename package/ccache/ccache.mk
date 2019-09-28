#
# ccache
#
HOST_CCACHE_BIN    = $(CCACHE)
HOST_CCACHE_BINDIR = $(HOST_DIR)/bin

HOST_CCACHE_LINKS = \
	ln -sf $(HOST_CCACHE_BIN) $(HOST_CCACHE_BINDIR)/cc; \
	ln -sf $(HOST_CCACHE_BIN) $(HOST_CCACHE_BINDIR)/gcc; \
	ln -sf $(HOST_CCACHE_BIN) $(HOST_CCACHE_BINDIR)/g++; \
	ln -sf $(HOST_CCACHE_BIN) $(HOST_CCACHE_BINDIR)/$(TARGET_CC); \
	ln -sf $(HOST_CCACHE_BIN) $(HOST_CCACHE_BINDIR)/$(TARGET_CXX)

HOST_CCACHE_ENV = \
	mkdir -p $(HOST_CCACHE_BINDIR); \
	mkdir -p $(HOST_DIR)/bin; \
	$(HOST_CCACHE_LINKS)

$(D)/ccache:
	$(START_BUILD)
	$(HOST_CCACHE_ENV)
	$(TOUCH)

# hack to make sure they are always copied
PHONY += host-ccache
