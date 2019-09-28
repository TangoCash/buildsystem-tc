#
# minidlna
#
MINIDLNA_VER    = 1.1.5
MINIDLNA_DIR    = minidlna-$(MINIDLNA_VER)
MINIDLNA_SOURCE = minidlna-$(MINIDLNA_VER).tar.gz
MINIDLNA_URL    = https://sourceforge.net/projects/minidlna/files/minidlna/$(MINIDLNA_VER)

$(ARCHIVE)/$(MINIDLNA_SOURCE):
	$(DOWNLOAD) $(MINIDLNA_URL)/$(MINIDLNA_SOURCE)

MINIDLNA_PATCH  = \
	minidlna.patch

$(D)/minidlna: bootstrap zlib sqlite libexif libjpeg-turbo libid3tag libogg libvorbis flac ffmpeg $(ARCHIVE)/$(MINIDLNA_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(MINIDLNA_DIR)
	$(UNTAR)/$(MINIDLNA_SOURCE)
	$(CHDIR)/$(MINIDLNA_DIR); \
		$(call apply_patches, $(MINIDLNA_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--localedir=/.remove/locale \
			; \
		$(MAKE); \
		$(MAKE) install prefix=/usr DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(MINIDLNA_DIR)
	$(TOUCH)
