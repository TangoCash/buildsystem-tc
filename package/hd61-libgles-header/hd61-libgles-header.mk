#
# hd61-libgles-header
#
HD61_LIBGLES_HEADER_VER    =
HD61_LIBGLES_HEADER_SOURCE = libgles-mali-utgard-headers.zip
HD61_LIBGLES_HEADER_URL    = https://github.com/HD-Digital/meta-gfutures/raw/release-6.2/recipes-bsp/mali/files

# currently same as hd60
#$(ARCHIVE)/$(HD61_LIBGLES_HEADER_SOURCE):
#	$(DOWNLOAD) $(HD61_LIBGLES_HEADER_URL)/$(HD61_LIBGLES_HEADER_SOURCE)

$(D)/hd61-libgles-header: bootstrap $(ARCHIVE)/$(HD61_LIBGLES_HEADER_SOURCE)
	$(START_BUILD)
	mkdir -p $(TARGET_DIR)/usr/lib
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(HD61_LIBGLES_HEADER_SOURCE) -d $(TARGET_DIR)/usr/include
	$(TOUCH)
