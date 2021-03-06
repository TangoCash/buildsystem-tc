#
# python-pyasn1-modules
#
PYTHON_PYASN1_MODULES_VER    = 0.1.4
PYTHON_PYASN1_MODULES_DIR    = pyasn1-modules-$(PYTHON_PYASN1_MODULES_VER)
PYTHON_PYASN1_MODULES_SOURCE = pyasn1-modules-$(PYTHON_PYASN1_MODULES_VER).tar.gz
PYTHON_PYASN1_MODULES_URL    = https://pypi.python.org/packages/source/p/pyasn1-modules

$(ARCHIVE)/$(PYTHON_PYASN1_MODULES_SOURCE):
	$(DOWNLOAD) $(PYTHON_PYASN1_MODULES_URL)/$(PYTHON_PYASN1_MODULES_SOURCE)

$(D)/python-pyasn1-modules: bootstrap python python-setuptools $(ARCHIVE)/$(PYTHON_PYASN1_MODULES_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(PYTHON_PYASN1_MODULES_DIR)
	$(UNTAR)/$(PYTHON_PYASN1_MODULES_SOURCE)
	$(CHDIR)/$(PYTHON_PYASN1_MODULES_DIR); \
		$(PYTHON_BUILD); \
		$(PYTHON_INSTALL)
	$(REMOVE)/$(PYTHON_PYASN1_MODULES_DIR)
	$(TOUCH)
