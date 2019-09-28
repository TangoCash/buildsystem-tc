#
# hd60-libgles-header
#
HD60_LIBGLES_HEADER_VER    = 
HD60_LIBGLES_HEADER_SOURCE = libgles-mali-utgard-headers.zip
HD60_LIBGLES_HEADER_URL    = https://github.com/HD-Digital/meta-gfutures/raw/release-6.2/recipes-bsp/mali/files

$(ARCHIVE)/$(HD60_LIBGLES_HEADER_SOURCE):
	$(DOWNLOAD) $(HD60_LIBGLES_HEADER_URL)/$(HD60_LIBGLES_HEADER_SOURCE)

$(D)/hd60-libgles-header: bootstrap $(ARCHIVE)/$(HD60_LIBGLES_HEADER_SOURCE)
	$(START_BUILD)
	mkdir -p $(TARGET_DIR)/usr/lib
	unzip -o $(SILENT_Q) $(ARCHIVE)/$(HD60_LIBGLES_HEADER_SOURCE) -d $(TARGET_DIR)/usr/include
	$(TOUCH)
