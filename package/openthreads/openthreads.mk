#
# openthreads
#
OPENTHREADS_VER    = 3.2
OPENTHREADS_DIR    = OpenThreads-$(OPENTHREADS_VER)
OPENTHREADS_SOURCE = OpenThreads-$(OPENTHREADS_VER).tar.gz
OPENTHREADS_URL    = https://sourceforge.net/projects/mxedeps/files

$(ARCHIVE)/$(OPENTHREADS_SOURCE):
	$(DOWNLOAD) $(OPENTHREADS_URL)/$(OPENTHREADS_SOURCE)

$(D)/openthreads: bootstrap $(ARCHIVE)/$(OPENTHREADS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(OPENTHREADS_DIR)
	$(UNTAR)/$(OPENTHREADS_SOURCE)
	$(CHDIR)/$(OPENTHREADS_DIR); \
		echo "# dummy file to prevent warning message" > examples/CMakeLists.txt; \
		$(CMAKE) \
			-DCMAKE_SUPPRESS_DEVELOPER_WARNINGS="1" \
			-D_OPENTHREADS_ATOMIC_USE_GCC_BUILTINS_EXITCODE="0" \
			| tail -n +90 \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(OPENTHREADS_DIR)
	$(TOUCH)
