#
# libao
#
LIBAO_VER    = 1.1.0
LIBAO_DIR    = libao-$(LIBAO_VER)
LIBAO_SOURCE = libao-$(LIBAO_VER).tar.gz
LIBAO_URL    = https://ftp.osuosl.org/pub/xiph/releases/ao

$(ARCHIVE)/$(LIBAO_SOURCE):
	$(DOWNLOAD) $(LIBAO_URL)/$(LIBAO_SOURCE)

$(D)/libao: bootstrap alsa-lib $(ARCHIVE)/$(LIBAO_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBAO_DIR)
	$(UNTAR)/$(LIBAO_SOURCE)
	$(CHDIR)/$(LIBAO_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--datadir=/.remove \
			--infodir=/.remove \
			--enable-shared \
			--disable-static \
			--enable-alsa \
			--enable-alsa-mmap \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libao.la
	$(REMOVE)/$(LIBAO_DIR)
	$(TOUCH)
