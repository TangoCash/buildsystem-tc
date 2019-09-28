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
	fix-hang-with-asset-upnp.patch \
	fix-incorrect-range-when-retrieving-content-via-HTTP.patch \
	fix-new-autotools.patch \
	fixed-crash-when-using-UTF-8-charset.patch \
	fixed-crash.patch \
	support-fstab-mounting.patch \
	support-seeking-in-large-2gb-files.patch

$(D)/djmount: bootstrap fuse $(ARCHIVE)/$(DJMOUNT_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(DJMOUNT_DIR)
	$(UNTAR)/$(DJMOUNT_SOURCE)
	$(CHDIR)/$(DJMOUNT_DIR); \
		touch libupnp/config.aux/config.rpath; \
		$(call apply_patches, $(DJMOUNT_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) -C \
			--prefix=/usr \
			--disable-debug \
			; \
		make; \
		make install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(DJMOUNT_DIR)
	$(TOUCH)
