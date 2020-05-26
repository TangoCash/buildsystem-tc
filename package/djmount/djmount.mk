#
# djmount
#
DJMOUNT_VER    = 0.71
DJMOUNT_DIR    = djmount-$(DJMOUNT_VER)
DJMOUNT_SOURCE = djmount-$(DJMOUNT_VER).tar.gz
DJMOUNT_URL    = https://sourceforge.net/projects/djmount/files/djmount/$(DJMOUNT_VER)

$(ARCHIVE)/$(DJMOUNT_SOURCE):
	$(DOWNLOAD) $(DJMOUNT_URL)/$(DJMOUNT_SOURCE)

DJMOUNT_PATCH  = \
	0001-fix-newer-gcc.patch \
	0002-fix-hang-with-asset-upnp.patch \
	0003-fix-incorrect-range-when-retrieving-content-via-HTTP.patch \
	0004-fix-new-autotools.patch \
	0005-fixed-crash-when-using-UTF-8-charset.patch \
	0006-fixed-crash.patch \
	0007-support-fstab-mounting.patch \
	0008-support-seeking-in-large-2gb-files.patch

$(D)/djmount: bootstrap fuse $(ARCHIVE)/$(DJMOUNT_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(DJMOUNT_DIR)
	$(UNTAR)/$(DJMOUNT_SOURCE)
	$(CHDIR)/$(DJMOUNT_DIR); \
		$(call apply_patches, $(DJMOUNT_PATCH)); \
		touch libupnp/config.aux/config.rpath; \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) -C \
			--prefix=/usr \
			--disable-debug \
			; \
		make; \
		make install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(DJMOUNT_DIR)
	$(TOUCH)
