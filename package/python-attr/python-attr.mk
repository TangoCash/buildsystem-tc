#
# python-attr
#
PYTHON_ATTR_VER    = 0.1.0
PYTHON_ATTR_DIR    = attr-$(PYTHON_ATTR_VER)
PYTHON_ATTR_SOURCE = attr-$(PYTHON_ATTR_VER).tar.gz
PYTHON_ATTR_URL    = https://pypi.python.org/packages/source/a/attr

$(ARCHIVE)/$(PYTHON_ATTR_SOURCE):
	$(DOWNLOAD) $(PYTHON_ATTR_URL)/$(PYTHON_ATTR_SOURCE)

$(D)/python-attr: bootstrap python python-setuptools $(ARCHIVE)/$(PYTHON_ATTR_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(PYTHON_ATTR_DIR)
	$(UNTAR)/$(PYTHON_ATTR_SOURCE)
	$(CHDIR)/$(PYTHON_ATTR_DIR); \
		$(PYTHON_BUILD); \
		$(PYTHON_INSTALL)
	$(REMOVE)/$(PYTHON_ATTR_DIR)
	$(TOUCH)
