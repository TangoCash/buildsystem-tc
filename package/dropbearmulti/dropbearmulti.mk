#
# dropbearmulti
#
DROPBEARMULTI_VER    = c8d852c
DROPBEARMULTI_DIR    = dropbearmulti-$(DROPBEARMULTI_VER)
DROPBEARMULTI_SOURCE = dropbearmulti-$(DROPBEARMULTI_VER).tar.bz2
DROPBEARMULTI_URL    = https://github.com/mkj/dropbear.git

$(ARCHIVE)/$(DROPBEARMULTI_SOURCE):
	$(HELPERS_DIR)/get-git-archive.sh $(DROPBEARMULTI_URL) $(DROPBEARMULTI_VER) $(notdir $@) $(ARCHIVE)

$(D)/dropbearmulti: bootstrap $(ARCHIVE)/$(DROPBEARMULTI_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(DROPBEARMULTI_DIR)
	$(UNTAR)/$(DROPBEARMULTI_SOURCE)
	$(CHDIR)/$(DROPBEARMULTI_DIR); \
		$(BUILD_ENV) \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--disable-syslog \
			--disable-lastlog \
			--infodir=/.remove \
			--localedir=/.remove/locale \
			--mandir=/.remove \
			--docdir=/.remove \
			--htmldir=/.remove \
			--dvidir=/.remove \
			--pdfdir=/.remove \
			--psdir=/.remove \
			--disable-shadow \
			--disable-zlib \
			--disable-utmp \
			--disable-utmpx \
			--disable-wtmp \
			--disable-wtmpx \
			--disable-loginfunc \
			--disable-pututline \
			--disable-pututxline \
			; \
		$(MAKE) PROGRAMS="dropbear scp" MULTI=1; \
		$(MAKE) PROGRAMS="dropbear scp" MULTI=1 install DESTDIR=$(TARGET_DIR)
	cd $(TARGET_DIR)/usr/bin && ln -sf /usr/bin/dropbearmulti dropbear
	mkdir -p $(TARGET_DIR)/etc/dropbear
	$(INSTALL_EXEC) $(PKG_FILES_DIR)/dropbear $(TARGET_DIR)/etc/init.d/
	$(REMOVE)/$(DROPBEARMULTI_DIR)
	$(TOUCH)
