#
# libvorbis
#
LIBVORBIS_VER    = 1.3.6
LIBVORBIS_DIR    = libvorbis-$(LIBVORBIS_VER)
LIBVORBIS_SOURCE = libvorbis-$(LIBVORBIS_VER).tar.xz
LIBVORBIS_URL    = https://ftp.osuosl.org/pub/xiph/releases/vorbis

$(ARCHIVE)/$(LIBVORBIS_SOURCE):
	$(DOWNLOAD) $(LIBVORBIS_URL)/$(LIBVORBIS_SOURCE)

$(D)/libvorbis: bootstrap libogg $(ARCHIVE)/$(LIBVORBIS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBVORBIS_DIR)
	$(UNTAR)/$(LIBVORBIS_SOURCE)
	$(CHDIR)/$(LIBVORBIS_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--docdir=/.remove \
			--mandir=/.remove \
			--disable-docs \
			--disable-examples \
			--disable-oggtest \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR) docdir=/.remove
	$(REWRITE_LIBTOOL)/libvorbis.la
	$(REWRITE_LIBTOOL)/libvorbisenc.la
	$(REWRITE_LIBTOOL)/libvorbisfile.la
	$(REMOVE)/$(LIBVORBIS_DIR)
	$(TOUCH)
