#
# openssh
#
OPENSSH_VER    = 8.2p1
OPENSSH_DIR    = openssh-$(OPENSSH_VER)
OPENSSH_SOURCE = openssh-$(OPENSSH_VER).tar.gz
OPENSSH_URL    = https://artfiles.org/openbsd/OpenSSH/portable

$(ARCHIVE)/$(OPENSSH_SOURCE):
	$(DOWNLOAD) $(OPENSSH_URL)/$(OPENSSH_SOURCE)

$(D)/openssh: bootstrap zlib openssl $(ARCHIVE)/$(OPENSSH_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(OPENSSH_DIR)
	$(UNTAR)/$(OPENSSH_SOURCE)
	$(CHDIR)/$(OPENSSH_DIR); \
		CC=$(TARGET_CC); \
		./configure $(SILENT_OPT) \
			$(CONFIGURE_OPTS) \
			--prefix=/usr \
			--mandir=/.remove \
			--sysconfdir=/etc/ssh \
			--libexecdir=/sbin \
			--with-privsep-path=/var/empty \
			--with-cppflags="-pipe -Os -I$(TARGET_INCLUDE_DIR)" \
			--with-ldflags=-"L$(TARGET_LIB_DIR)" \
			; \
		$(MAKE); \
		$(MAKE) install-nokeys DESTDIR=$(TARGET_DIR)
	$(INSTALL_EXEC) $(BUILD_DIR)/openssh-$(OPENSSH_VER)/opensshd.init $(TARGET_DIR)/etc/init.d/openssh
	sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' $(TARGET_DIR)/etc/ssh/sshd_config
	$(REMOVE)/$(OPENSSH_DIR)
	$(TOUCH)
