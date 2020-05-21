#
# set up build environment for other makefiles
#
# -----------------------------------------------------------------------------

#SHELL := $(SHELL) -x

CONFIG_SITE =
export CONFIG_SITE

# -----------------------------------------------------------------------------

# set up default parallelism
PARALLEL_JOBS := $(shell echo $$((1 + `getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1`)))
override MAKE = make $(if $(findstring j,$(filter-out --%,$(MAKEFLAGS))),,-j$(PARALLEL_JOBS)) $(SILENT_OPT)

MAKEFLAGS             += --no-print-directory

# -----------------------------------------------------------------------------

BASE_DIR              := $(shell pwd)
ARCHIVE               ?= $(HOME)/Archive
BUILD_DIR              = $(BASE_DIR)/build_tmp
ifeq ($(NEWLAYOUT), 1)
RELEASE_DIR            = $(BASE_DIR)/release/linuxrootfs1
else
RELEASE_DIR            = $(BASE_DIR)/release
endif
DEPS_DIR               = $(BASE_DIR)/.deps
D                      = $(BASE_DIR)/.deps
HOST_DIR               = $(BASE_DIR)/host
TARGET_DIR             = $(BASE_DIR)/root
SOURCE_DIR             = $(BASE_DIR)/build_source
RELEASE_IMAGE_DIR      = $(BASE_DIR)/release_image
HELPERS_DIR            = $(BASE_DIR)/helpers
OWN_FILES             ?= $(BASE_DIR)/own-files
CROSS_BASE             = $(BASE_DIR)/cross
CROSS_DIR              = $(CROSS_BASE)/$(BOXARCH)-$(CROSSTOOL_GCC_VER)-kernel-$(KERNEL_VER)

BUILD                 ?= $(shell /usr/share/libtool/config.guess 2>/dev/null || /usr/share/libtool/config/config.guess 2>/dev/null || /usr/share/misc/config.guess 2>/dev/null)

PKG_NAME               = $(basename $(@F))
PKG_UPPER              = $(call UPPERCASE,$(PKG_NAME))
PKG_LOWER              = $(call LOWERCASE,$(PKG_NAME))
PKG_VER                = $($(PKG_UPPER)_VER)
PKG_DIR                = $($(PKG_UPPER)_DIR)
PKG_SOURCE             = $($(PKG_UPPER)_SOURCE)
PKG_URL                = $($(PKG_UPPER)_URL)
PKG_BUILD_DIR          = $(BUILD_DIR)/$(PKG_DIR)
PKG_FILES_DIR          = $(BASE_DIR)/package/$(subst host-,,$(basename $(@F)))/files
PKG_PATCHES_DIR        = $(BASE_DIR)/package/$(subst host-,,$(basename $(@F)))/patches

START_BUILD = \
	@echo ""; \
	echo -e "$(TERM_GREEN)Start building$(TERM_NORMAL) \nName    : $(PKG_NAME) \nVersion : $(PKG_VER) \nSource  : $(PKG_SOURCE)"

TOUCH = \
	@touch $@; echo -e "$(TERM_GREEN)completed$(TERM_NORMAL)"; \
	echo ""; \
	$(call draw_line);

DATE                   = $(shell date '+%Y-%m-%d_%H.%M')

TINKER_OPTION         ?= 0

# -----------------------------------------------------------------------------

CCACHE                 = /usr/bin/ccache
CCACHE_DIR             = $(HOME)/.ccache-bs-$(BOXARCH)-max
export CCACHE_DIR

# -----------------------------------------------------------------------------

ifeq ($(BOXARCH), arm)
TARGET                ?= arm-cortex-linux-gnueabihf
BOXARCH               ?= arm
TARGET_ABI             = -mtune=cortex-a15 -mfloat-abi=hard -mfpu=neon-vfpv4 -march=armv7ve
endif

ifeq ($(BOXARCH), aarch64)
TARGET                ?= aarch64-unknown-linux-gnu
BOXARCH               ?= aarch64
TARGET_ABI             =
endif

ifeq ($(BOXARCH), mips)
TARGET                ?= mipsel-unknown-linux-gnu
BOXARCH               ?= mips
TARGET_ABI             = -march=mips32 -mtune=mips32
endif

OPTIMIZATIONS         ?= size
ifeq ($(OPTIMIZATIONS), size)
TARGET_OPTIMIZATION    = -pipe -Os
TARGET_EXTRA_CFLAGS    = -ffunction-sections -fdata-sections
TARGET_EXTRA_LDFLAGS   = -Wl,--gc-sections
endif

ifeq ($(OPTIMIZATIONS), normal)
TARGET_OPTIMIZATION    = -pipe -O2
TARGET_EXTRA_CFLAGS    =
TARGET_EXTRA_LDFLAGS   =
endif

ifeq ($(OPTIMIZATIONS), debug)
TARGET_OPTIMIZATION    = -O0 -g
TARGET_EXTRA_CFLAGS    =
TARGET_EXTRA_LDFLAGS   =
endif

ifeq ($(BS_GCC_VER), 6.5.0)
CROSSTOOL_GCC_VER = gcc-6.5.0
endif

ifeq ($(BS_GCC_VER), 7.5.0)
CROSSTOOL_GCC_VER = gcc-7.5.0
endif

ifeq ($(BS_GCC_VER), 8.4.0)
CROSSTOOL_GCC_VER = gcc-8.4.0
endif

ifeq ($(BS_GCC_VER), 9.2.0)
CROSSTOOL_GCC_VER = gcc-9.2.0
endif

TARGET_LIB_DIR         = $(TARGET_DIR)/usr/lib
TARGET_INCLUDE_DIR     = $(TARGET_DIR)/usr/include
TARGET_SHARE_DIR       = $(TARGET_DIR)/usr/share

TARGET_CFLAGS          = $(TARGET_OPTIMIZATION) $(TARGET_ABI) $(TARGET_EXTRA_CFLAGS) -I$(TARGET_INCLUDE_DIR)
TARGET_CPPFLAGS        = $(TARGET_CFLAGS)
TARGET_CXXFLAGS        = $(TARGET_CFLAGS)
TARGET_LDFLAGS         = -Wl,-rpath -Wl,/usr/lib -Wl,-rpath-link -Wl,$(TARGET_LIB_DIR) -L$(TARGET_LIB_DIR) -L$(TARGET_DIR)/lib $(TARGET_EXTRA_LDFLAGS)
LD_FLAGS               = $(TARGET_LDFLAGS)

TARGET_CROSS           = $(TARGET)-

# Define TARGET_xx variables for all common binutils/gcc
TARGET_AR              = $(TARGET_CROSS)ar
TARGET_AS              = $(TARGET_CROSS)as
TARGET_CC              = $(TARGET_CROSS)gcc
TARGET_CPP             = $(TARGET_CROSS)cpp
TARGET_CXX             = $(TARGET_CROSS)g++
TARGET_LD              = $(TARGET_CROSS)ld
TARGET_NM              = $(TARGET_CROSS)nm
TARGET_OBJCOPY         = $(TARGET_CROSS)objcopy
TARGET_OBJDUMP         = $(TARGET_CROSS)objdump
TARGET_RANLIB          = $(TARGET_CROSS)ranlib
TARGET_READELF         = $(TARGET_CROSS)readelf
TARGET_STRIP           = $(TARGET_CROSS)strip

# -----------------------------------------------------------------------------

TERM_RED               = \033[40;0;31m
TERM_RED_BOLD          = \033[40;1;31m
TERM_GREEN             = \033[40;0;32m
TERM_GREEN_BOLD        = \033[40;1;32m
TERM_YELLOW            = \033[40;0;33m
TERM_YELLOW_BOLD       = \033[40;1;33m
TERM_NORMAL            = \033[0m

# -----------------------------------------------------------------------------

# search path(s) for all prerequisites
VPATH                  = $(D)
PATH                  := $(HOST_DIR)/bin:$(CROSS_DIR)/bin:$(PATH)

# -----------------------------------------------------------------------------

PKG_CONFIG             = $(HOST_DIR)/bin/$(TARGET)-pkg-config
PKG_CONFIG_LIBDIR      = $(TARGET_LIB_DIR)/pkgconfig
PKG_CONFIG_PATH        = $(TARGET_LIB_DIR)/pkgconfig

# -----------------------------------------------------------------------------

# rewrite-"functions"
#   fix directories is libtool .la files and .pc files
REWRITE_LIBTOOL_RULES = \
	sed -i \
	-e "s,^libdir=.*,libdir='$(TARGET_LIB_DIR)'," \
	-e "s,\(^dependency_libs='\| \|-L\|^dependency_libs='\)/usr/lib,\ $(TARGET_LIB_DIR),g"

REWRITE_LIBTOOL = \
	$(REWRITE_LIBTOOL_RULES) $(TARGET_LIB_DIR)

REWRITE_CONFIG_RULES = \
	sed -i \
	-e "s,^prefix=.*,prefix='$(TARGET_DIR)/usr'," \
	-e "s,^exec_prefix=.*,exec_prefix='$(TARGET_DIR)/usr'," \
	-e "s,^libdir=.*,libdir='$(TARGET_LIB_DIR)'," \
	-e "s,^includedir=.*,includedir='$(TARGET_INCLUDE_DIR)',"

REWRITE_CONFIG  = \
	$(REWRITE_CONFIG_RULES)

REWRITE_PKGCONF = \
	$(REWRITE_CONFIG_RULES) $(PKG_CONFIG_PATH)

# -----------------------------------------------------------------------------

# download archives into archives directory
DOWNLOAD               = wget --no-check-certificate $(DOWNLOAD_SILENT_OPT) -t3 -T60 -c -P $(ARCHIVE)

# unpack archives into build directory
UNTAR                  = $(SILENT)tar -C $(BUILD_DIR) -xf $(ARCHIVE)

# clean up
REMOVE                 = $(SILENT)rm -rf $(BUILD_DIR)

# apply patches
PATCH = patch -p1 -i $(PATCHES)

# build helper variables
CD                     = set -e; cd
CHDIR                  = $(CD) $(BUILD_DIR)
MKDIR                  = mkdir -p $(BUILD_DIR)
CPDIR                  = cp -a -t $(BUILD_DIR) $(ARCHIVE)
STRIP                  = $(TARGET)-strip

INSTALL                = install
INSTALL_CONF           = $(INSTALL) -m 0600
INSTALL_DATA           = $(INSTALL) -m 0644
INSTALL_EXEC           = $(INSTALL) -m 0755

# empty variable EMPTY for smoother comparisons
EMPTY =

GET-GIT-ARCHIVE        = $(HELPERS_DIR)/get-git-archive.sh
GET-GIT-SOURCE         = $(HELPERS_DIR)/get-git-source.sh
GET-SVN-SOURCE         = $(HELPERS_DIR)/get-svn-source.sh
UPDATE-RC.D            = $(HELPERS_DIR)/update-rc.d -r $(TARGET_DIR)

# -----------------------------------------------------------------------------

MAKE_OPTS = \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	CC="$(TARGET_CC)" \
	GCC="$(TARGET_CC)" \
	CPP="$(TARGET_CPP)" \
	CXX="$(TARGET_CXX)" \
	LD="$(TARGET_LD)" \
	AR="$(TARGET_AR)" \
	AS="$(TARGET_AS)" \
	NM="$(TARGET_NM)" \
	OBJCOPY="$(TARGET_OBJCOPY)" \
	OBJDUMP="$(TARGET_OBJDUMP)" \
	RANLIB="$(TARGET_RANLIB)" \
	READELF="$(TARGET_READELF)" \
	STRIP="$(TARGET_STRIP)" \
	ARCH=$(BOXARCH)

BUILD_ENV = \
	$(MAKE_OPTS) \
	\
	CFLAGS="$(TARGET_CFLAGS)" \
	CPPFLAGS="$(TARGET_CPPFLAGS)" \
	CXXFLAGS="$(TARGET_CXXFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)"

BUILD_ENV += \
	PKG_CONFIG_PATH="" \
	PKG_CONFIG_LIBDIR=$(PKG_CONFIG_LIBDIR) \
	PKG_CONFIG_SYSROOT_DIR=$(TARGET_DIR)

CONFIGURE_OPTS = \
	--build=$(BUILD) \
	--host=$(TARGET) \
	$(SILENT_CONFIGURE)

CONFIGURE = \
	test -f ./configure || ./autogen.sh $(SILENT_OPT) && \
	$(BUILD_ENV) \
	./configure $(CONFIGURE_OPTS) $(SILENT_OPT)

# -----------------------------------------------------------------------------

CMAKE_OPTS = \
	-DBUILD_SHARED_LIBS=ON \
	-DENABLE_STATIC=OFF \
	-DCMAKE_BUILD_TYPE="None" \
	-DCMAKE_SYSTEM_NAME="Linux" \
	-DCMAKE_SYSTEM_PROCESSOR="$(BOXARCH)" \
	-DCMAKE_INSTALL_PREFIX="/usr" \
	-DCMAKE_INSTALL_DOCDIR="/.remove" \
	-DCMAKE_INSTALL_MANDIR="/.remove" \
	-DCMAKE_PREFIX_PATH="$(TARGET_DIR)" \
	-DCMAKE_INCLUDE_PATH="$(TARGET_INCLUDE_DIR)" \
	-DCMAKE_C_COMPILER="$(TARGET_CC)" \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) -DNDEBUG" \
	-DCMAKE_CPP_COMPILER="$(TARGET_CPP)" \
	-DCMAKE_CPP_FLAGS="$(TARGET_CFLAGS) -DNDEBUG" \
	-DCMAKE_CXX_COMPILER="$(TARGET_CXX)" \
	-DCMAKE_CXX_FLAGS="$(TARGET_CFLAGS) -DNDEBUG" \
	-DCMAKE_LINKER="$(TARGET_LD)" \
	-DCMAKE_AR="$(TARGET_AR)" \
	-DCMAKE_AS="$(TARGET_AS)" \
	-DCMAKE_NM="$(TARGET_NM)" \
	-DCMAKE_OBJCOPY="$(TARGET_OBJCOPY)" \
	-DCMAKE_OBJDUMP="$(TARGET_OBJDUMP)" \
	-DCMAKE_RANLIB="$(TARGET_RANLIB)" \
	-DCMAKE_READELF="$(TARGET_READELF)" \
	-DCMAKE_STRIP="$(TARGET_STRIP)"

CMAKE = \
	rm -f CMakeCache.txt; \
	cmake . --no-warn-unused-cli $(CMAKE_OPTS)

# -----------------------------------------------------------------------------

TUXBOX_CUSTOMIZE = [ -x $(HELPERS_DIR)/$(notdir $@)-local.sh ] && \
	$(HELPERS_DIR)/$(notdir $@)-local.sh \
	$(RELEASE_DIR) \
	$(TARGET_DIR) \
	$(BASE_DIR) \
	$(SOURCE_DIR) \
	$(RELEASE_IMAGE_DIR) \
	$(BOXMODEL) \
	$(FLAVOUR) \
	$(DATE) \
	|| true
