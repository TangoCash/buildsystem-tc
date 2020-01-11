#
# crosstool-ng
#
crosstool-backup:
	if [ -e $(CROSSTOOL_NG_BACKUP) ]; then \
		mv $(CROSSTOOL_NG_BACKUP) $(CROSSTOOL_NG_BACKUP).old; \
	fi; \
	cd $(CROSS_DIR); \
	tar czvf $(CROSSTOOL_NG_BACKUP) *

crosstool-restore: $(CROSSTOOL_NG_BACKUP)
	rm -rf $(CROSS_DIR) ; \
	if [ ! -e $(CROSS_DIR) ]; then \
		mkdir -p $(CROSS_DIR); \
	fi;
	tar xzvf $(CROSSTOOL_NG_BACKUP) -C $(CROSS_DIR)

crosstool-renew:
	ccache -cCz
	make distclean
	rm -rf $(CROSS_DIR)
	make crosstool

# -----------------------------------------------------------------------------

CROSSTOOL_NG_VER     = git
CROSSTOOL_NG_DIR     = crosstool-ng.$(CROSSTOOL_NG_VER)
CROSSTOOL_NG_SOURCE  = $(CROSSTOOL_NG_DIR)
CROSSTOOL_NG_URL     = $(MAX-GIT-GITHUB)/crosstool-ng.git
CROSSTOOL_NG_ARCHIVE = $(ARCHIVE)/archive-crosstool-ng
CROSSTOOL_NG_CONFIG  = crosstool-ng-$(CROSSTOOL_NG_VER)-$(CROSSTOOL_GCC_VER)-$(BOXARCH)
CROSSTOOL_NG_BACKUP  = $(CROSSTOOL_NG_ARCHIVE)/$(CROSSTOOL_NG_CONFIG)-kernel-$(KERNEL_VER)-backup.tar.gz

CROSSTOOL_NG_PATCH   =
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), vuduo vuduo4k vusolo4k vuultimo4k vuuno4k vuuno4kse vuzero4k))
CROSSTOOL_NG_PATCH  += crosstool-ng-vu-kernel.patch
endif

$(CROSSTOOL_NG_ARCHIVE):
	mkdir -p $@

# -----------------------------------------------------------------------------

CUSTOM_KERNEL = $(ARCHIVE)/$(KERNEL_SOURCE)
ifeq ($(BOXMODEL), $(filter $(BOXMODEL),hd51 bre2ze4k h7))
CUSTOM_KERNEL_VER = $(KERNEL_VER)-arm
endif

ifeq ($(BOXMODEL), $(filter $(BOXMODEL),hd60 hd61))
CUSTOM_KERNEL_VER = $(KERNEL_VER)-$(KERNEL_DATE)-arm
endif

ifeq ($(BOXMODEL), vuduo)
CUSTOM_KERNEL_VER = $(KERNEL_VER)
endif

ifeq ($(BOXMODEL), $(filter $(BOXMODEL), vuduo4k vusolo4k vuultimo4k vuuno4k vuuno4kse vuzero4k))
CUSTOM_KERNEL_VER = $(KERNEL_SOURCE_VER)
endif

ifeq ($(BOXMODEL), $(filter $(BOXMODEL), osmio4k osmio4kplus))
CUSTOM_KERNEL_VER = edision-$(KERNEL_SOURCE_VER)
endif

# -----------------------------------------------------------------------------

ifeq ($(wildcard $(CROSS_DIR)/build.log.bz2),)
CROSSTOOL = crosstool
crosstool:
	make MAKEFLAGS=--no-print-directory crosstool-ng
	if [ ! -e $(CROSSTOOL_NG_BACKUP) ]; then \
		make crosstool-backup; \
	fi;

crosstool-ng: directories $(CROSSTOOL_NG_ARCHIVE) $(ARCHIVE)/$(KERNEL_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(CROSSTOOL_NG_DIR)
	$(GET-GIT-SOURCE) $(CROSSTOOL_NG_URL) $(CROSSTOOL_NG_ARCHIVE)/$(CROSSTOOL_NG_SOURCE)
	$(CPDIR)/archive-crosstool-ng/$(CROSSTOOL_NG_DIR)
	unset CONFIG_SITE LIBRARY_PATH CPATH C_INCLUDE_PATH PKG_CONFIG_PATH CPLUS_INCLUDE_PATH INCLUDE; \
	$(CHDIR)/$(CROSSTOOL_NG_DIR); \
		$(INSTALL_DATA) $(PKG_FILES_DIR)/$(CROSSTOOL_NG_CONFIG).config .config; \
		NUM_CPUS=$$(expr `getconf _NPROCESSORS_ONLN` \* 2); \
		MEM_512M=$$(awk '/MemTotal/ {M=int($$2/1024/512); print M==0?1:M}' /proc/meminfo); \
		test $$NUM_CPUS -gt $$MEM_512M && NUM_CPUS=$$MEM_512M; \
		test $$NUM_CPUS = 0 && NUM_CPUS=1; \
		sed -i "s@^CT_PARALLEL_JOBS=.*@CT_PARALLEL_JOBS=$$NUM_CPUS@" .config; \
		\
		$(call apply_patches, $(CROSSTOOL_NG_PATCH)); \
		\
		export CT_NG_ARCHIVE=$(CROSSTOOL_NG_ARCHIVE); \
		export CT_NG_BASE_DIR=$(CROSS_DIR); \
		export CT_NG_CUSTOM_KERNEL=$(CUSTOM_KERNEL); \
		export CT_NG_CUSTOM_KERNEL_VER=$(CUSTOM_KERNEL_VER); \
		test -f ./configure || ./bootstrap && \
		./configure --enable-local; \
		MAKELEVEL=0 make; \
		chmod 0755 ct-ng; \
		./ct-ng oldconfig; \
		./ct-ng build
	test -e $(CROSS_DIR)/$(TARGET)/lib || ln -sf sys-root/lib $(CROSS_DIR)/$(TARGET)/
	rm -f $(CROSS_DIR)/$(TARGET)/sys-root/lib/libstdc++.so.6.0.*-gdb.py
	$(REMOVE)/$(CROSSTOOL_NG_DIR)
endif

# -----------------------------------------------------------------------------

crosstool-config:
	make MAKEFLAGS=--no-print-directory crosstool-ng-config

crosstool-ng-config: directories
	$(REMOVE)/$(CROSSTOOL_NG_DIR)
	$(GET-GIT-SOURCE) $(CROSSTOOL_NG_URL) $(CROSSTOOL_NG_ARCHIVE)/$(CROSSTOOL_NG_SOURCE)
	$(CPDIR)/archive-crosstool-ng/$(CROSSTOOL_NG_DIR)
	unset CONFIG_SITE; \
	$(CHDIR)/$(CROSSTOOL_NG_DIR); \
		$(INSTALL_DATA) $(subst -config,,$(PKG_FILES_DIR))/$(CROSSTOOL_NG_CONFIG).config .config; \
		test -f ./configure || ./bootstrap && \
		./configure --enable-local; \
		MAKELEVEL=0 make; \
		chmod 0755 ct-ng; \
		./ct-ng menuconfig

# -----------------------------------------------------------------------------

crosstool-upgradeconfig:
	make MAKEFLAGS=--no-print-directory crosstool-ng-upgradeconfig

crosstool-ng-upgradeconfig: directories
	$(REMOVE)/$(CROSSTOOL_NG_DIR)
	$(GET-GIT-SOURCE) $(CROSSTOOL_NG_URL) $(CROSSTOOL_NG_ARCHIVE)/$(CROSSTOOL_NG_SOURCE)
	$(CPDIR)/archive-crosstool-ng/$(CROSSTOOL_NG_DIR)
	unset CONFIG_SITE; \
	$(CHDIR)/$(CROSSTOOL_NG_DIR); \
		$(INSTALL_DATA) $(subst -upgradeconfig,,$(PKG_FILES_DIR))/$(CROSSTOOL_NG_CONFIG).config .config; \
		test -f ./configure || ./bootstrap && \
		./configure --enable-local; \
		MAKELEVEL=0 make; \
		./ct-ng upgradeconfig
