#
# jfsutils
#
JFSUTILS_VER    = 1.1.15
JFSUTILS_DIR    = jfsutils-$(JFSUTILS_VER)
JFSUTILS_SOURCE = jfsutils-$(JFSUTILS_VER).tar.gz
JFSUTILS_URL    = http://jfs.sourceforge.net/project/pub

$(ARCHIVE)/$(JFSUTILS_SOURCE):
	$(DOWNLOAD) $(JFSUTILS_URL)/$(JFSUTILS_SOURCE)

JFSUTILS_PATCH  = \
	0001-jfsutils.patch

$(D)/jfsutils: bootstrap e2fsprogs $(ARCHIVE)/$(JFSUTILS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(JFSUTILS_DIR)
	$(UNTAR)/$(JFSUTILS_SOURCE)
	$(CHDIR)/$(JFSUTILS_DIR); \
		$(call apply_patches, $(JFSUTILS_PATCH)); \
		sed -i "/unistd.h/a#include <sys/types.h>" fscklog/extract.c; \
		sed -i "/ioctl.h/a#include <sys/sysmacros.h>" libfs/devices.c; \
		$(CONFIGURE) \
			--target=$(TARGET) \
			--prefix= \
			--mandir=/.remove \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	rm -f $(addprefix $(TARGET_DIR)/sbin/,jfs_debugfs jfs_fscklog jfs_logdump)
	$(REMOVE)/$(JFSUTILS_DIR)
	$(TOUCH)
