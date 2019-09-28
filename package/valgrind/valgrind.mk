#
# valgrind
#
VALGRIND_VER    = 3.13.0
VALGRIND_DIR    = valgrind-$(VALGRIND_VER)
VALGRIND_SOURCE = valgrind-$(VALGRIND_VER).tar.bz2
VALGRIND_URL    = ftp://sourceware.org/pub/valgrind

$(ARCHIVE)/$(VALGRIND_SOURCE):
	$(DOWNLOAD) $(VALGRIND_URL)/$(VALGRIND_SOURCE)

$(D)/valgrind: bootstrap $(ARCHIVE)/$(VALGRIND_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(VALGRIND_DIR)
	$(UNTAR)/$(VALGRIND_SOURCE)
	$(CHDIR)/$(VALGRIND_DIR); \
		sed -i -e "s#armv7#arm#g" configure; \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--datadir=/.remove \
			-enable-only32bit \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	rm -f $(addprefix $(TARGET_DIR)/usr/lib/valgrind/,*.a *.xml)
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,cg_* callgrind_* ms_print)
	$(REMOVE)/$(VALGRIND_DIR)
	$(TOUCH)
