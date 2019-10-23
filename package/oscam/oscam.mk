#
# oscam
#
OSCAM_FLAVOUR ?= oscam-smod

ifeq ($(OSCAM_FLAVOUR), oscam)
OSCAM_FLAVOUR_URL = https://repo.or.cz/oscam.git
OSCAM_FLAVOUR_DIR = oscam.git
else ifeq ($(OSCAM_FLAVOUR), oscam-smod)
OSCAM_FLAVOUR_URL = https://github.com/Schimmelreiter/oscam-smod
OSCAM_FLAVOUR_DIR = oscam-smod.git
endif

# -----------------------------------------------------------------------------

OSCAM_VER = $(OSCAM_FLAVOUR)
OSCAM_SOURCE = $(OSCAM_FLAVOUR_URL)
OSCAM_CONFIG = 
OSCAM_PATCH  =

$(D)/oscam.do_prepare:
	$(START_BUILD)
	$(REMOVE)/$(OSCAM_FLAVOUR_DIR)
	$(GET-GIT-SOURCE) $(OSCAM_FLAVOUR_URL) $(ARCHIVE)/$(OSCAM_FLAVOUR_DIR)
	$(CPDIR)/$(OSCAM_FLAVOUR_DIR)
	$(CHDIR)/$(OSCAM_FLAVOUR_DIR); \
		$(call apply_patches, $(OSCAM_PATCH)); \
		$(SHELL) ./config.sh --disable all \
		--enable WEBIF \
			CS_ANTICASC \
			CS_CACHEEX \
			CW_CYCLE_CHECK \
			CLOCKFIX \
			HAVE_DVBAPI \
			IRDETO_GUESSING \
			MODULE_MONITOR \
			READ_SDT_CHARSETS \
			TOUCH \
			WEBIF_JQUERY \
			WEBIF_LIVELOG \
			WITH_DEBUG \
			WITH_EMU \
			WITH_LB \
			WITH_NEUTRINO \
			\
			MODULE_CAMD35 \
			MODULE_CAMD35_TCP \
			MODULE_CCCAM \
			MODULE_CCCSHARE \
			MODULE_CONSTCW \
			MODULE_GBOX \
			MODULE_NEWCAMD \
			\
			READER_CONAX \
			READER_CRYPTOWORKS \
			READER_IRDETO \
			READER_NAGRA \
			READER_NAGRA_MERLIN \
			READER_SECA \
			READER_VIACCESS \
			READER_VIDEOGUARD \
			\
			CARDREADER_INTERNAL \
			CARDREADER_PHOENIX \
			CARDREADER_SMARGO \
			CARDREADER_SC8IN1 \
			$(OSCAM_CONFIG) 
	@touch $@

$(D)/oscam.do_compile:
	$(CHDIR)/$(OSCAM_FLAVOUR_DIR); \
		$(BUILD_ENV) \
		$(MAKE) CROSS=$(TARGET_CROSS) USE_LIBCRYPTO=1 USE_LIBUSB=1 \
		PLUS_TARGET="-rezap" \
		CONF_DIR=/var/keys \
		EXTRA_LDFLAGS="$(TARGET_LDFLAGS)" \
		CC_OPTS=" -Os -pipe "
	@touch $@

$(D)/oscam: bootstrap openssl libusb oscam.do_prepare oscam.do_compile
	rm -rf $(RELEASE_IMAGE_DIR)/$(OSCAM_FLAVOUR)
	mkdir $(RELEASE_IMAGE_DIR)/$(OSCAM_FLAVOUR)
	cp -pR $(BUILD_DIR)/$(OSCAM_FLAVOUR_DIR)/Distribution/* $(RELEASE_IMAGE_DIR)/$(OSCAM_FLAVOUR)/
	$(REMOVE)/$(OSCAM_FLAVOUR_DIR)
	$(TOUCH)

oscam-clean:
	rm -f $(D)/oscam
	rm -f $(D)/oscam.do_compile
	$(CHDIR)/$(OSCAM_FLAVOUR_DIR); \
		$(MAKE) distclean

oscam-distclean:
	rm -f $(D)/oscam*
