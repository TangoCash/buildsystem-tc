#
# gmp
#
GMP_VER    = 6.1.2
GMP_DIR    = gmp-$(GMP_VER)
GMP_SOURCE = gmp-$(GMP_VER).tar.xz
GMP_URL    = https://gmplib.org/download/gmp

$(ARCHIVE)/$(GMP_SOURCE):
	$(DOWNLOAD) $(GMP_URL)/$(GMP_SOURCE)

$(D)/gmp: bootstrap gmp $(ARCHIVE)/$(GMP_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(GMP_DIR)
	$(UNTAR)/$(GMP_SOURCE)
	$(CHDIR)/$(GMP_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--infodir=/.remove \
			--enable-silent-rules \
		        ; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libgmp.la
	$(REMOVE)/$(GMP_DIR)
	$(TOUCH)
