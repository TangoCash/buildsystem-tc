#
# rpcbind
#
RPCBIND_VER    = 1.2.5
RPCBIND_DIR    = rpcbind-$(RPCBIND_VER)
RPCBIND_SOURCE = rpcbind-$(RPCBIND_VER).tar.bz2
RPCBIND_URL    = https://sourceforge.net/projects/rpcbind/files/rpcbind/$(RPCBIND_VER)

$(ARCHIVE)/$(RPCBIND_SOURCE):
	$(DOWNLOAD) $(RPCBIND_URL)/$(RPCBIND_SOURCE)

RPCBIND_PATCH  = \
	0001-Remove-yellow-pages-support.patch

$(D)/rpcbind: bootstrap libtirpc $(ARCHIVE)/$(RPCBIND_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(RPCBIND_DIR)
	$(UNTAR)/$(RPCBIND_SOURCE)
	$(CHDIR)/$(RPCBIND_DIR); \
		$(call apply_patches, $(RPCBIND_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) CFLAGS="$(TARGET_CFLAGS) `$(PKG_CONFIG) --cflags libtirpc`" \
			--prefix=/usr \
			--bindir=/usr/sbin \
			--mandir=/.remove \
			--enable-silent-rules \
			--with-rpcuser=root \
			--with-systemdsystemunitdir=no \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(INSTALL_DATA) $(PKG_FILES_DIR)/rpc $(TARGET_DIR)/etc/rpc
	$(INSTALL_DATA) $(PKG_FILES_DIR)/rpcbind.conf $(TARGET_DIR)/etc/rpcbind.conf
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/rpcbind.init $(TARGET_DIR)/etc/init.d/rpcbind
	$(UPDATE-RC.D) rpcbind start 12 2 3 4 5 . stop 60 0 1 6 .
	$(REMOVE)/$(RPCBIND_DIR)
	$(TOUCH)
