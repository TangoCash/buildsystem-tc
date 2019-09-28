#
# aio-grab
#
AIO_GRAB_VER    = git
AIO_GRAB_DIR    = aio-grab.$(AIO_GRAB_VER)
AIO_GRAB_SOURCE = $(AIO_GRAB_DIR)
AIO_GRAB_URL    = https://github.com/oe-alliance/$(AIO_GRAB_SOURCE)

$(D)/aio-grab: bootstrap zlib libpng libjpeg-turbo
	$(START_BUILD)
	$(REMOVE)/$(AIO_GRAB_DIR)
	$(GET-GIT-SOURCE) $(AIO_GRAB_URL) $(ARCHIVE)/$(AIO_GRAB_SOURCE)
	$(CPDIR)/$(AIO_GRAB_DIR)
	$(CHDIR)/$(AIO_GRAB_DIR); \
		autoreconf -fi $(SILENT_OPT); \
		automake --foreign --include-deps $(SILENT_OPT); \
		$(BUILD_ENV) \
		./configure $(SILENT_OPT) \
			--build=$(BUILD) \
			--host=$(TARGET) \
			--target=$(TARGET) \
			--prefix= \
			--enable-silent-rules \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(AIO_GRAB_DIR)
	$(TOUCH)
