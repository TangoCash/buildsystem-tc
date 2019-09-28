#
# libnsl
#
LIBNSL_VER    = 1.2.0
LIBNSL_DIR    = libnsl-$(LIBNSL_VER)
LIBNSL_SOURCE = libnsl-$(LIBNSL_VER).tar.gz
LIBNSL_URL    = https://github.com/thkukuk/libnsl/archive

$(ARCHIVE)/$(LIBNSL_SOURCE):
	$(DOWNLOAD) $(LIBNSL_URL)/v$(LIBNSL_VER).tar.gz -O $@

$(D)/libnsl: bootstrap libtirpc $(ARCHIVE)/$(LIBNSL_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(LIBNSL_DIR)
	$(UNTAR)/$(LIBNSL_SOURCE)
	$(CHDIR)/$(LIBNSL_DIR); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--sysconfdir=/etc \
		; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL)/libnsl.la
	$(REMOVE)/$(LIBNSL_DIR)
	mv $(TARGET_DIR)/usr/lib/libnsl.so.2* $(TARGET_DIR)/lib; \
	ln -sfv ../../lib/libnsl.so.2.0.0 $(TARGET_DIR)/usr/lib/libnsl.so
	$(TOUCH)
