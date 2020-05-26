#
# python-twisted
#
PYTHON_TWISTED_VER    = 18.4.0
PYTHON_TWISTED_DIR    = Twisted-$(PYTHON_TWISTED_VER)
PYTHON_TWISTED_SOURCE = Twisted-$(PYTHON_TWISTED_VER).tar.bz2
PYTHON_TWISTED_URL    = https://pypi.python.org/packages/source/T/Twisted

$(ARCHIVE)/$(PYTHON_TWISTED_SOURCE):
	$(DOWNLOAD) $(PYTHON_TWISTED_URL)/$(PYTHON_TWISTED_SOURCE)

PYTHON_TWISTED_PATCH  = \
	0001-fix-writing-after-channel-is-closed.patch

$(D)/python-twisted: bootstrap python python-setuptools python-zope-interface python-constantly python-incremental python-pyopenssl python-service-identity $(ARCHIVE)/$(PYTHON_TWISTED_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(PYTHON_TWISTED_DIR)
	$(UNTAR)/$(PYTHON_TWISTED_SOURCE)
	$(CHDIR)/$(PYTHON_TWISTED_DIR); \
		$(call apply_patches, $(PYTHON_TWISTED_PATCH)); \
		$(PYTHON_BUILD); \
		$(PYTHON_INSTALL)
	$(REMOVE)/$(PYTHON_TWISTED_DIR)
	$(TOUCH)
