#
# libvorbisidec
#
LIBVORBISIDEC_VER    = 1.2.1+git20180316
LIBVORBISIDEC_DIR    = libvorbisidec-$(LIBVORBISIDEC_VER)
LIBVORBISIDEC_SOURCE = libvorbisidec_$(LIBVORBISIDEC_VER).orig.tar.gz
LIBVORBISIDEC_URL    = https://ftp.de.debian.org/debian/pool/main/libv/libvorbisidec

$(ARCHIVE)/$(LIBVORBISIDEC_SOURCE):
	$(DOWNLOAD) $(LIBVORBISIDEC_URL)/$(LIBVORBISIDEC_SOURCE)

$(D)/libvorbisidec: bootstrap libogg $(ARCHIVE)/$(LIBVORBISIDEC_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBVORBISIDEC_DIR)
	$(UNTAR)/$(LIBVORBISIDEC_SOURCE)
	$(CHDIR)/$(LIBVORBISIDEC_DIR); \
		ACLOCAL_FLAGS="-I . -I $(TARGET_DIR)/usr/share/aclocal" \
		$(BUILD_ENV) \
		./autogen.sh $(SILENT_OPT) \
			--host=$(TARGET) \
			--build=$(BUILD) \
			--prefix=/usr \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libvorbisidec.la
	$(REMOVE)/$(LIBVORBISIDEC_DIR)
	$(TOUCH)
