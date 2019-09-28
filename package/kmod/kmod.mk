#
# kmod
#
KMOD_VER    = 26
KMOD_DIR    = kmod-$(KMOD_VER)
KMOD_SOURCE = kmod-$(KMOD_VER).tar.xz
KMOD_URL    = https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod

$(ARCHIVE)/$(KMOD_SOURCE):
	$(DOWNLOAD) $(KMOD_URL)/$(KMOD_SOURCE)

KMOD_PATCH  = \
	0001-fix-O_CLOEXEC.patch \
	avoid_parallel_tests.patch \
	libkmod_pc_in.patch

$(D)/kmod: bootstrap zlib $(ARCHIVE)/$(KMOD_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(KMOD_DIR)
	$(UNTAR)/$(KMOD_SOURCE)
	$(CHDIR)/$(KMOD_DIR); \
		$(call apply_patches, $(KMOD_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--bindir=/bin \
			--disable-static \
			--enable-shared \
			--disable-manpages \
			--sysconfdir=/etc \
			--with-rootlibdir=/lib \
			--with-zlib \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
		for target in depmod insmod lsmod modinfo modprobe rmmod; do \
			ln -sfv ../bin/kmod $(TARGET_DIR)/sbin/$$target; \
		done
	$(REWRITE_LIBTOOL)/libkmod.la
	mkdir -p $(TARGET_DIR)/lib/{depmod.d,modprobe.d}
	mkdir -p $(TARGET_DIR)/etc/{depmod.d,modprobe.d}
	$(REMOVE)/$(KMOD_DIR)
	$(TOUCH)
