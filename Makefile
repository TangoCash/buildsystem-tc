#
# Master makefile
#
# -----------------------------------------------------------------------------

MAINTAINER := $(shell whoami)
MAIN_ID := $(shell echo -en "\x74\x68\x6f\x6d\x61\x73")
UID := $(shell id -u)
ifeq ($(UID), 0)
warn:
	@echo "You are running as root. Do not do this, it is dangerous."
	@echo "Aborting the build. Log in as a regular user and retry."
else ifeq ($(MAINTAINER), $(MAIN_ID))
warn:
	@echo "Aborting the build. Log in as a regular user and retry."
else

ifndef HOSTAR
HOSTAR := ar
endif
ifndef HOSTAS
HOSTAS := as
endif
ifndef HOSTCC
HOSTCC := gcc
HOSTCC := $(shell which $(HOSTCC) || type -p $(HOSTCC) || echo gcc)
endif
HOSTCC_NOCCACHE := $(HOSTCC)
ifndef HOSTCXX
HOSTCXX := g++
HOSTCXX := $(shell which $(HOSTCXX) || type -p $(HOSTCXX) || echo g++)
endif
HOSTCXX_NOCCACHE := $(HOSTCXX)
ifndef HOSTCPP
HOSTCPP := cpp
endif
ifndef HOSTLD
HOSTLD := ld
endif
ifndef HOSTLN
HOSTLN := ln
endif
ifndef HOSTNM
HOSTNM := nm
endif
ifndef HOSTOBJCOPY
HOSTOBJCOPY := objcopy
endif
ifndef HOSTRANLIB
HOSTRANLIB := ranlib
endif
HOSTAR := $(shell which $(HOSTAR) || type -p $(HOSTAR) || echo ar)
HOSTAS := $(shell which $(HOSTAS) || type -p $(HOSTAS) || echo as)
HOSTCPP := $(shell which $(HOSTCPP) || type -p $(HOSTCPP) || echo cpp)
HOSTLD := $(shell which $(HOSTLD) || type -p $(HOSTLD) || echo ld)
HOSTLN := $(shell which $(HOSTLN) || type -p $(HOSTLN) || echo ln)
HOSTNM := $(shell which $(HOSTNM) || type -p $(HOSTNM) || echo nm)
HOSTOBJCOPY := $(shell which $(HOSTOBJCOPY) || type -p $(HOSTOBJCOPY) || echo objcopy)
HOSTRANLIB := $(shell which $(HOSTRANLIB) || type -p $(HOSTRANLIB) || echo ranlib)

export HOSTAR HOSTAS HOSTCC HOSTCXX HOSTLD
export HOSTCC_NOCCACHE HOSTCXX_NOCCACHE
export LANG = C
export LC_ALL = C

# -----------------------------------------------------------------------------

-include .config
-include config.local
include make/environment-linux.mk
include make/environment-build.mk
include make/environment-target.mk

# -----------------------------------------------------------------------------

local-files:
	@test -e config.local || cp $(HELPERS_DIR)/example.config.local config.local
	@test -e Makefile.local || cp $(HELPERS_DIR)/example.Makefile.local Makefile.local

# -----------------------------------------------------------------------------
#  A print out of environment variables
#
# maybe a help about all supported targets would be nice here, too...
#
printenv:
	@$(call draw_line);
	@echo "Build Environment Variables:"
	@echo "PATH              : `type -p fmt>/dev/null&&echo $(PATH)|sed 's/:/ /g' |fmt -65|sed 's/ /:/g; 2,$$s/^/                  : /;'||echo $(PATH)`"
	@echo "ARCHIVE_DIR       : $(ARCHIVE)"
	@echo "BASE_DIR          : $(BASE_DIR)"
	@echo "HELPERS_DIR       : $(HELPERS_DIR)"
	@echo "CROSS_BASE        : $(CROSS_BASE)"
	@echo "CROSS_DIR         : $(CROSS_DIR)"
	@echo "RELEASE_DIR       : $(RELEASE_DIR)"
	@echo "RELEASE_IMAGE_DIR : $(RELEASE_IMAGE_DIR)"
	@echo "HOST_DIR          : $(HOST_DIR)"
	@echo "TARGET_DIR        : $(TARGET_DIR)"
	@echo "KERNEL_DIR        : $(KERNEL_DIR)"
	@echo "MAINTAINER        : $(MAINTAINER)"
	@echo "BUILD             : $(BUILD)"
	@echo "TARGET            : $(TARGET)"
	@echo "BOXTYPE           : $(BOXTYPE)"
	@echo "BOXARCH           : $(BOXARCH)"
	@echo "BOXMODEL          : $(BOXMODEL)"
	@echo "KERNEL_VERSION    : $(KERNEL_VER)"
	@echo "PARALLEL_JOBS     : $(PARALLEL_JOBS)"
	@echo "VERBOSE_BUILD     : $(KBUILD_VERBOSE)"
	@echo "CROSS_GCC_VERSION : $(CROSSTOOL_GCC_VER)"
	@echo "OPTIMIZATION      : $(OPTIMIZATIONS)"
	@echo -e "FLAVOUR           : $(TERM_YELLOW)$(FLAVOUR)$(TERM_NORMAL)"
	@echo "EXTERNAL_LCD      : $(EXTERNAL_LCD)"
ifeq ($(NEWLAYOUT), 1)
	@echo -e "IMAGE TYPE        : $(TERM_YELLOW)1 single + multirootfs$(TERM_NORMAL)"
endif
	@$(call draw_line);
	@echo -e "LOCAL_N_PLUGIN_BUILD_OPTIONS : $(TERM_GREEN)$(LOCAL_N_PLUGIN_BUILD_OPTIONS)$(TERM_NORMAL)"
	@echo -e "LOCAL_NEUTRINO_BUILD_OPTIONS : $(TERM_GREEN)$(LOCAL_NEUTRINO_BUILD_OPTIONS)$(TERM_NORMAL)"
	@echo -e "LOCAL_NEUTRINO_CFLAGS        : $(TERM_GREEN)$(LOCAL_NEUTRINO_CFLAGS)$(TERM_NORMAL)"
	@echo -e "LOCAL_NEUTRINO_DEPS          : $(TERM_GREEN)$(LOCAL_NEUTRINO_DEPS)$(TERM_NORMAL)"
	@$(call draw_line);
	@make --no-print-directory toolcheck
ifeq ($(MAINTAINER),)
	@echo "##########################################################################"
	@echo "# The MAINTAINER variable is not set. It defaults to your name from the  #"
	@echo "# passwd entry, but this seems to have failed. Please set it in 'config'.#"
	@echo "##########################################################################"
	@echo
endif
	@if ! test -e $(BASE_DIR)/.config; then \
		echo;echo "If you want to create or modify the configuration, run './make.sh'"; \
		echo; fi

help:
	@echo "a few helpful make targets:"
	@echo "* make crosstool           - build cross toolchain"
	@echo "* make bootstrap           - prepares for building"
	@echo "* make print-targets       - print out all available targets"
	@echo ""
	@echo "later, you might find these useful:"
	@echo "* make update-self         - update the build system"
	@echo "* make update              - update the build system including make distclean"
	@echo ""
	@echo "cleantargets:"
	@echo "make clean                 - Clears everything except kernel."
	@echo "make distclean             - Clears the whole construction."
	@echo

# -----------------------------------------------------------------------------

include make/flashimage.mk
include make/helpers.mk
include $(sort $(wildcard package/*/*.mk))
include make/cleantargets.mk

include make/bootstrap.mk

# -----------------------------------------------------------------------------

update-self:
	git pull

update:
	$(MAKE) distclean
	@if test -d $(BASE_DIR); then \
		cd $(BASE_DIR)/; \
		echo '===================================================================='; \
		echo '      updating buildsystem git repository                           '; \
		echo '===================================================================='; \
		echo; \
		if [ "$(GIT_STASH_PULL)" = "stashpull" ]; then \
			git stash && git stash show -p > ./pull-stash-buildsystem.patch || true && git pull && git stash pop || true; \
		else \
			git pull; \
		fi; \
	fi
	@echo;

# -----------------------------------------------------------------------------

# To put more focus on warnings, be less verbose as default
# Use 'make V=1' to see the full commands
ifeq ("$(origin V)", "command line")
KBUILD_VERBOSE = $(V)
endif
ifeq ("$(origin S)", "command line")
KBUILD_VERBOSE = $(S)
endif
# set the default verbosity
ifndef KBUILD_VERBOSE
KBUILD_VERBOSE = 0
endif
ifeq ($(KBUILD_VERBOSE), 0)
SILENT              = @
SILENT_CONFIGURE    = >/dev/null 2>&1
SILENT_OPT          = >/dev/null 2>&1
SILENT_PATCH        =
SILENT_Q            = -q
DOWNLOAD_SILENT_OPT = -o /dev/null
$(VERBOSE).SILENT:
endif
ifeq ($(KBUILD_VERBOSE), 1)
SILENT              =
SILENT_CONFIGURE    =
SILENT_OPT          =
SILENT_PATCH        =
SILENT_Q            = -q
DOWNLOAD_SILENT_OPT = -o /dev/null
endif
ifeq ($(KBUILD_VERBOSE), 2)
SILENT              = @
SILENT_CONFIGURE    = -q
SILENT_OPT          =
SILENT_PATCH        =
SILENT_Q            = -q
DOWNLOAD_SILENT_OPT = -o /dev/null
endif

# -----------------------------------------------------------------------------

all:
	@echo "'make all' is not a valid target. Please execute 'make print-targets' to display the alternatives."

# for local extensions, e.g. special plugins or similar...
-include ./Makefile.local

# debug target, if you need that, you know it. If you don't know if you need
# that, you don't need it.
.print-phony:
	@echo $(PHONY)

PHONY += local-files
PHONY += print-targets
PHONY += printenv help all everything
PHONY += update update-self
PHONY += .print-phony
.PHONY: $(PHONY)

# this makes sure we do not build top-level dependencies in parallel
# (which would not be too helpful anyway, running many configure and
# downloads in parallel...), but the sub-targets are still built in
# parallel, which is useful on multi-processor / multi-core machines
.NOTPARALLEL:

endif
