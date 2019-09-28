#
# rpcsvc-proto
#
RPCSVC_PROTO_VER    = 1.4
RPCSVC_PROTO_DIR    = rpcsvc-proto-$(RPCSVC_PROTO_VER)
RPCSVC_PROTO_SOURCE = rpcsvc-proto-$(RPCSVC_PROTO_VER).tar.xz
RPCSVC_PROTO_URL    = https://github.com/thkukuk/rpcsvc-proto/releases/download/v$(RPCSVC_PROTO_VER)

$(ARCHIVE)/$(RPCSVC_PROTO_SOURCE):
	$(DOWNLOAD) $(RPCSVC_PROTO_URL)/$(RPCSVC_PROTO_SOURCE)

RPCSVC_PROTO_PATCH  = \
	0001-Use-cross-compiled-rpcgen.patch

$(D)/rpcsvc-proto: bootstrap $(ARCHIVE)/$(RPCSVC_PROTO_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(RPCSVC_PROTO_DIR)
	$(UNTAR)/$(RPCSVC_PROTO_SOURCE)
	$(CHDIR)/$(RPCSVC_PROTO_DIR); \
		$(call apply_patches, $(RPCSVC_PROTO_PATCH)); \
		autoreconf -fi $(SILENT_OPT); \
		$(CONFIGURE) \
			--prefix=/usr \
			--sysconfdir=/etc \
		; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(RPCSVC_PROTO_DIR)
	$(TOUCH)
