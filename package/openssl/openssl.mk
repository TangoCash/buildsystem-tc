#
# openssl
#
OPENSSL_VER    = 1.0.2s
OPENSSL_DIR    = openssl-$(OPENSSL_VER)
OPENSSL_SOURCE = openssl-$(OPENSSL_VER).tar.gz
OPENSSL_URL    = https://www.openssl.org/source

$(ARCHIVE)/$(OPENSSL_SOURCE):
	$(DOWNLOAD) $(OPENSSL_URL)/$(OPENSSL_SOURCE)

OPENSSL_PATCH  = \
	openssl-optimize-for-size.patch \
	openssl-makefile-dirs.patch \
	openssl-disable_doc_tests.patch \
	openssl-fix-parallel-building.patch \
	openssl-compat_versioned_symbols-1.patch \
	openssl-remove_timestamp_check.patch

ifeq ($(BOXARCH), arm)
OPENSSL_TARGET_ARCH = linux-armv4
else ifeq ($(BOXARCH), aarch64)
OPENSSL_TARGET_ARCH = linux-aarch64
else ifeq ($(BOXARCH), mips)
OPENSSL_TARGET_ARCH = linux-generic32
endif

$(D)/openssl: bootstrap $(ARCHIVE)/$(OPENSSL_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(OPENSSL_DIR)
	$(UNTAR)/$(OPENSSL_SOURCE)
	$(CHDIR)/$(OPENSSL_DIR); \
		$(call apply_patches, $(OPENSSL_PATCH)); \
		./Configure $(SILENT_OPT) \
			$(OPENSSL_TARGET_ARCH) \
			-DL_ENDIAN \
			shared \
			no-hw \
			\
			$(TARGET_CFLAGS) \
			-DTERMIOS -fomit-frame-pointer \
			-DOPENSSL_SMALL_FOOTPRINT \
			$(TARGET_LDFLAGS) \
			\
			--cross-compile-prefix=$(TARGET_CROSS) \
			--prefix=/usr \
			--openssldir=/etc/ssl \
			; \
		$(MAKE) depend; \
		$(MAKE) all; \
		$(MAKE) install_sw INSTALL_PREFIX=$(TARGET_DIR)
	chmod 0755 $(TARGET_DIR)/usr/lib/lib{crypto,ssl}.so.*
	cd $(TARGET_DIR) && rm -rf etc/ssl/man usr/bin/openssl usr/lib/engines
	ln -sf libcrypto.so.1.0.0 $(TARGET_LIB_DIR)/libcrypto.so.0.9.8
	ln -sf libssl.so.1.0.0 $(TARGET_LIB_DIR)/libssl.so.0.9.8
	$(REMOVE)/$(OPENSSL_DIR)
	$(TOUCH)
