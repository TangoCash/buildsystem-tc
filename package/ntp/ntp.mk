#
# ntp
#
NTP_VER    = 4.2.8p14
NTP_DIR    = ntp-$(NTP_VER)
NTP_SOURCE = ntp-$(NTP_VER).tar.gz
NTP_URL    = https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-$(basename $(NTP_VER))

$(ARCHIVE)/$(NTP_SOURCE):
	$(DOWNLOAD) $(NTP_URL)/$(NTP_SOURCE)

NTP_PATCH  = \
	ntp.patch

$(D)/ntp: bootstrap $(ARCHIVE)/$(NTP_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(NTP_DIR)
	$(UNTAR)/$(NTP_SOURCE)
	$(CHDIR)/$(NTP_DIR); \
		$(call apply_patches, $(NTP_PATCH)); \
		$(CONFIGURE) \
			--target=$(TARGET) \
			--prefix=/usr \
			--mandir=/.remove \
			--docdir=/.remove \
			--disable-tick \
			--disable-tickadj \
			--disable-debugging \
			--with-yielding-select=yes \
			--without-ntpsnmpd \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(NTP_DIR)
	$(TOUCH)
