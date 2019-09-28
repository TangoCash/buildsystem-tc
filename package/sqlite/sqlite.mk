#
# sqlite
#
SQLITE_VER    = 3280000
SQLITE_DIR    = sqlite-autoconf-$(SQLITE_VER)
SQLITE_SOURCE = sqlite-autoconf-$(SQLITE_VER).tar.gz
SQLITE_URL    = http://www.sqlite.org/2019

$(ARCHIVE)/$(SQLITE_SOURCE):
	$(DOWNLOAD) $(SQLITE_URL)/$(SQLITE_SOURCE)

$(D)/sqlite: bootstrap $(ARCHIVE)/$(SQLITE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(SQLITE_DIR)
	$(UNTAR)/$(SQLITE_SOURCE)
	$(CHDIR)/$(SQLITE_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libsqlite3.la
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,sqlite3)
	$(REMOVE)/$(SQLITE_DIR)
	$(TOUCH)
