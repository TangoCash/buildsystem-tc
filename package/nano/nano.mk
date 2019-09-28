#
# nano
#
NANO_VER    = 2.2.6
NANO_DIR    = nano-$(NANO_VER)
NANO_SOURCE = nano-$(NANO_VER).tar.gz
NANO_URL    = https://www.nano-editor.org/dist/v$(basename $(NANO_VER))

$(ARCHIVE)/$(NANO_SOURCE):
	$(DOWNLOAD) $(NANO_URL)/$(NANO_SOURCE)

$(D)/nano: bootstrap $(ARCHIVE)/$(NANO_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(NANO_DIR)
	$(UNTAR)/$(NANO_SOURCE)
	$(CHDIR)/$(NANO_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--infodir=/.remove \
			--localedir=/.remove/locale \
			--mandir=/.remove \
			--disable-nls \
			--enable-tiny \
			--enable-color \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(NANO_DIR)
	$(TOUCH)
