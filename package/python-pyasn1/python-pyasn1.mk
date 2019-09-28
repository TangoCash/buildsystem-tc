#
# python-pyasn1
#
PYTHON_PYASN1_VER    = 0.3.6
PYTHON_PYASN1_DIR    = pyasn1-$(PYTHON_PYASN1_VER)
PYTHON_PYASN1_SOURCE = pyasn1-$(PYTHON_PYASN1_VER).tar.gz
PYTHON_PYASN1_URL    = https://pypi.python.org/packages/source/p/pyasn1

$(ARCHIVE)/$(PYTHON_PYASN1_SOURCE):
	$(DOWNLOAD) $(PYTHON_PYASN1_URL)/$(PYTHON_PYASN1_SOURCE)

$(D)/python-pyasn1: bootstrap python python-setuptools python-pyasn1-modules $(ARCHIVE)/$(PYTHON_PYASN1_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(PYTHON_PYASN1_DIR)
	$(UNTAR)/$(PYTHON_PYASN1_SOURCE)
	$(CHDIR)/$(PYTHON_PYASN1_DIR); \
		$(PYTHON_BUILD); \
		$(PYTHON_INSTALL)
	$(REMOVE)/$(PYTHON_PYASN1_DIR)
	$(TOUCH)
