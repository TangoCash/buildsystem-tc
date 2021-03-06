#
# python-setuptools
#
PYTHON_SETUPTOOLS_VER    = 5.2
PYTHON_SETUPTOOLS_DIR    = setuptools-$(PYTHON_SETUPTOOLS_VER)
PYTHON_SETUPTOOLS_SOURCE = setuptools-$(PYTHON_SETUPTOOLS_VER).tar.gz
PYTHON_SETUPTOOLS_URL    = https://pypi.python.org/packages/source/s/setuptools

$(ARCHIVE)/$(PYTHON_SETUPTOOLS_SOURCE):
	$(DOWNLOAD) $(PYTHON_SETUPTOOLS_URL)/$(PYTHON_SETUPTOOLS_SOURCE)

$(D)/python-setuptools: bootstrap python $(ARCHIVE)/$(PYTHON_SETUPTOOLS_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(PYTHON_SETUPTOOLS_DIR)
	$(UNTAR)/$(PYTHON_SETUPTOOLS_SOURCE)
	$(CHDIR)/$(PYTHON_SETUPTOOLS_DIR); \
		$(PYTHON_BUILD); \
		$(PYTHON_INSTALL)
	$(REMOVE)/$(PYTHON_SETUPTOOLS_DIR)
	$(TOUCH)
