#
# base-passwd
#
BASE_PASSWD_VER    = 3.5.29
BASE_PASSWD_DIR    = base-passwd-$(BASE_PASSWD_VER)
BASE_PASSWD_SOURCE = base-passwd_$(BASE_PASSWD_VER).tar.gz
BASE_PASSWD_URL    = https://launchpad.net/debian/+archive/primary/+files

$(ARCHIVE)/$(BASE_PASSWD_SOURCE):
	$(DOWNLOAD) $(BASE_PASSWD_URL)/$(BASE_PASSWD_SOURCE)

BASE_PASSWD_PATCH  = \
	0001-add_shutdown.patch \
	0002-nobash.patch \
	0003-noshadow.patch \
	0004-input.patch \
	0005-disable-docs.patch \
	0006-add_static.patch

$(D)/base-passwd: bootstrap $(ARCHIVE)/$(BASE_PASSWD_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(BASE_PASSWD_DIR)
	$(UNTAR)/$(BASE_PASSWD_SOURCE)
	$(CHDIR)/$(BASE_PASSWD_DIR); \
		$(call apply_patches, $(BASE_PASSWD_PATCH)); \
		$(CONFIGURE) \
			--prefix=/usr \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR); \
		$(INSTALL_DATA) passwd.master $(TARGET_DIR)/etc/passwd; \
		$(INSTALL_DATA) group.master $(TARGET_DIR)/etc/group
	$(REMOVE)/$(BASE_PASSWD_DIR)
	$(TOUCH)
