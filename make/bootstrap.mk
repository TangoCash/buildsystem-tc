TOOLCHECK  = find-git find-svn find-gzip find-bzip2 find-patch find-gawk
TOOLCHECK += find-makeinfo find-automake find-gcc find-libtool
TOOLCHECK += find-yacc find-flex find-tic find-pkg-config find-help2man
TOOLCHECK += find-cmake find-gperf

find-%:
	@TOOL=$(patsubst find-%,%,$@); \
		type -p $$TOOL >/dev/null || \
		{ echo "required tool $$TOOL missing."; false; }

toolcheck: $(TOOLCHECK) preqs
	@echo "All required tools seem to be installed."
	@echo
	@if test "$(subst /bin/,,$(shell readlink /bin/sh))" != bash; then \
		echo "WARNING: /bin/sh is not linked to bash."; \
		echo "         This configuration might work, but is not supported."; \
		echo; \
	fi

#
# preqs
#
preqs:
	mkdir -p $(OWN_FILES)/neutrino-hd
	mkdir -p $(OWN_FILES)/neutrino-hd.$(BOXMODEL)

#
# directories
#
$(D)/directories:
	$(START_BUILD)
	mkdir -p $(D)
	mkdir -p $(ARCHIVE)
	mkdir -p $(BUILD_DIR)
	mkdir -p $(HOST_DIR)
	mkdir -p $(RELEASE_IMAGE_DIR)
	mkdir -p $(SOURCE_DIR)
	mkdir -p $(HOST_DIR)/{bin,lib,share}
	mkdir -p $(TARGET_DIR)/{bin,boot,etc,lib,sbin,usr,var}
	mkdir -p $(TARGET_DIR)/etc/{default,init.d,udev,network,ssl}
	mkdir -p $(TARGET_DIR)/etc/default/volatiles
	mkdir -p $(TARGET_DIR)/etc/rc{{0..6},S}.d
	mkdir -p $(TARGET_DIR)/etc/network/if-{post-down,pre-up,up,down}.d
	mkdir -p $(TARGET_DIR)/lib/firmware
	mkdir -p $(TARGET_DIR)/usr/{bin,include,lib,sbin,share}
	mkdir -p $(TARGET_DIR)/usr/lib/pkgconfig
	mkdir -p $(TARGET_DIR)/var/{bin,etc,lib,spool,tuxbox,volatile}
	mkdir -p $(TARGET_DIR)/var/lib/{alsa,modules,nfs,opkg,urandom}
	$(TOUCH)

#
# cross-libs
#
$(D)/cross-libs: directories $(CROSSTOOL)
	$(START_BUILD)
	if test -e $(CROSS_DIR)/$(TARGET)/sys-root/lib; then \
		cp -a $(CROSS_DIR)/$(TARGET)/sys-root/lib/*so* $(TARGET_DIR)/lib; \
		cp -a $(CROSS_DIR)/$(TARGET)/sys-root/etc/* $(TARGET_DIR)/etc; \
	else \
		cp -a $(CROSS_DIR)/$(TARGET)/lib/*so* $(TARGET_DIR)/lib; \
		cp -a $(CROSS_DIR)/$(TARGET)/etc/* $(TARGET_DIR)/etc; \
	fi; \
	if [ $(BOXARCH) = "aarch64" ]; then \
		cd ${TARGET_DIR}; ln -sf lib lib64; \
		cd ${TARGET_DIR}/usr; ln -sf lib lib64; \
	fi
	$(TOUCH)

#
# bootstrap
#
BOOTSTRAP  = directories
BOOTSTRAP += ccache
BOOTSTRAP += $(CROSSTOOL)
BOOTSTRAP += cross-libs
BOOTSTRAP += pkgconf

$(D)/bootstrap: $(BOOTSTRAP)
	@touch $@

#
# system-tools
#
SYSTEM_TOOLS  =
SYSTEM_TOOLS += bash
SYSTEM_TOOLS += procps-ng
SYSTEM_TOOLS += kmod
SYSTEM_TOOLS += sysvinit
SYSTEM_TOOLS += base-files
SYSTEM_TOOLS += e2fsprogs
SYSTEM_TOOLS += dosfstools
SYSTEM_TOOLS += tzdata
#SYSTEM_TOOLS += jfsutils
SYSTEM_TOOLS += hd-idle
SYSTEM_TOOLS += rpcbind
#SYSTEM_TOOLS += portmap
SYSTEM_TOOLS += nfs-utils
SYSTEM_TOOLS += htop
SYSTEM_TOOLS += vsftpd
SYSTEM_TOOLS += autofs
SYSTEM_TOOLS += parted
SYSTEM_TOOLS += ethtool
SYSTEM_TOOLS += udpxy
SYSTEM_TOOLS += dvbsnoop
SYSTEM_TOOLS += fbshot
SYSTEM_TOOLS += ofgwrite
SYSTEM_TOOLS += aio-grab
SYSTEM_TOOLS += wget
SYSTEM_TOOLS += busybox

$(D)/system-tools: $(SYSTEM_TOOLS)
	@touch $@
