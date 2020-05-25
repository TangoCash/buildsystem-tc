#
# mtd-utils
#
MTD_UTILS_VER    = 1.5.2
MTD_UTILS_DIR    = mtd-utils-$(MTD_UTILS_VER)
MTD_UTILS_SOURCE = mtd-utils-$(MTD_UTILS_VER).tar.bz2
MTD_UTILS_URL    = ftp://ftp.infradead.org/pub/mtd-utils

$(ARCHIVE)/$(MTD_UTILS_SOURCE):
	$(DOWNLOAD) $(MTD_UTILS_URL)/$(MTD_UTILS_SOURCE)

MTD_UTILS_PATCH  = \
	0002-mtd-utils-sysmacros.patch

$(D)/mtd-utils: bootstrap zlib lzo e2fsprogs $(ARCHIVE)/$(MTD_UTILS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(MTD_UTILS_DIR)
	$(UNTAR)/$(MTD_UTILS_SOURCE)
	$(CHDIR)/$(MTD_UTILS_DIR); \
		$(call apply_patches, $(MTD_UTILS_PATCH)); \
		$(BUILD_ENV) \
		$(MAKE) PREFIX= CC=$(TARGET_CC) LD=$(TARGET_LD) STRIP=$(TARGET_STRIP) WITHOUT_XATTR=1 DESTDIR=$(TARGET_DIR); \
		cp -a $(BUILD_DIR)/mtd-utils-$(MTD_UTILS_VER)/mkfs.jffs2 $(TARGET_DIR)/usr/sbin
		cp -a $(BUILD_DIR)/mtd-utils-$(MTD_UTILS_VER)/sumtool $(TARGET_DIR)/usr/sbin
	$(REMOVE)/$(MTD_UTILS_DIR)
	$(TOUCH)

#
# host-mtd-utils
#
HOST_MTD_UTILS_VER    = $(MTD_UTILS_VER)
HOST_MTD_UTILS_DIR    = mtd-utils-$(HOST_MTD_UTILS_VER)
HOST_MTD_UTILS_SOURCE = $(MTD_UTILS_SOURCE)

HOST_MTD_UTILS_PATCH  = \
	0001-mtd-utils.patch \
	0002-mtd-utils-sysmacros.patch

$(D)/host-mtd-utils: directories $(ARCHIVE)/$(HOST_MTD_UTILS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(HOST_MTD_UTILS_DIR)
	$(UNTAR)/$(HOST_MTD_UTILS_SOURCE)
	$(CHDIR)/$(HOST_MTD_UTILS_DIR); \
		$(call apply_patches, $(HOST_MTD_UTILS_PATCH)); \
		$(MAKE) `pwd`/mkfs.jffs2 `pwd`/sumtool BUILDDIR=`pwd` WITHOUT_XATTR=1 DESTDIR=$(HOST_DIR); \
		$(MAKE) install DESTDIR=$(HOST_DIR)/bin
	$(REMOVE)/$(HOST_MTD_UTILS_DIR)
	$(TOUCH)
