#
# strace
#
STRACE_VER    = 5.1
STRACE_DIR    = strace-$(STRACE_VER)
STRACE_SOURCE = strace-$(STRACE_VER).tar.xz
STRACE_URL    = https://strace.io/files/$(STRACE_VER)

$(ARCHIVE)/$(STRACE_SOURCE):
	$(DOWNLOAD) $(STRACE_URL)/$(STRACE_SOURCE)

$(D)/strace: bootstrap $(ARCHIVE)/$(STRACE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(STRACE_DIR)
	$(UNTAR)/$(STRACE_SOURCE)
	$(CHDIR)/$(STRACE_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--enable-silent-rules \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,strace-graph strace-log-merge)
	$(REMOVE)/$(STRACE_DIR)
	$(TOUCH)
