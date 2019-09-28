#
# gdb
#
GDB_VER    = 8.1.1
GDB_DIR    = gdb-$(GDB_VER)
GDB_SOURCE = gdb-$(GDB_VER).tar.xz
GDB_URL    = https://sourceware.org/pub/gdb/releases

$(ARCHIVE)/$(GDB_SOURCE):
	$(DOWNLOAD) $(GDB_URL)/$(GDB_SOURCE)

$(D)/gdb: bootstrap zlib ncurses $(ARCHIVE)/$(GDB_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(GDB_DIR)
	$(UNTAR)/$(GDB_SOURCE)
	$(CHDIR)/$(GDB_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--infodir=/.remove \
			--disable-binutils \
			--disable-werror \
			--with-curses \
			--with-zlib \
			--enable-static \
			; \
		$(MAKE) all-gdb; \
		$(MAKE) install-gdb DESTDIR=$(TARGET_DIR)
	rm -rf $(addprefix $(TARGET_DIR)/usr/share/,system-gdbinit)
	find $(TARGET_SHARE_DIR)/gdb/syscalls -type f -not -name 'arm-linux.xml' -not -name 'gdb-syscalls.dtd' -print0 | xargs -0 rm --
	$(REMOVE)/$(GDB_DIR)
	$(TOUCH)
