#
# makefile to keep buildsystem helpers
#
# -----------------------------------------------------------------------------

# BS Revision
BS_REV=$(shell cd $(BASE_DIR); git log | grep "^commit" | wc -l)
# Neutrino mp Revision
NMP_REV=$(shell cd $(SOURCE_DIR)/$(NEUTRINO); git log | grep "^commit" | wc -l)
# libstb-hal Revision
HAL_REV=$(shell cd $(SOURCE_DIR)/$(LIBSTB_HAL); git log | grep "^commit" | wc -l)

# -----------------------------------------------------------------------------

# apply patch sets
define apply_patches
	l=$(strip $(2)); test -z $$l && l=1; \
	for i in $(1); do \
		if [ -d $$i ]; then \
			for p in $$i/*; do \
				echo -e "$(TERM_YELLOW)Applying patch $(PKG_NAME):$(TERM_NORMAL) `basename $$p`"; \
				if [ $${p:0:1} == "/" ]; then \
					patch -p$$l $(SILENT_PATCH) -i $$p; \
				else \
					patch -p$$l $(SILENT_PATCH) -i $(PKG_PATCHES_DIR)/$$p; \
				fi; \
			done; \
		else \
			echo -e "$(TERM_YELLOW)Applying patch $(PKG_NAME)$(TERM_NORMAL): `basename $$i`"; \
			if [ $${i:0:1} == "/" ]; then \
				patch -p$$l $(SILENT_PATCH) -i $$i; \
			else \
				patch -p$$l $(SILENT_PATCH) -i $(PKG_PATCHES_DIR)/$$i; \
			fi; \
		fi; \
	done
endef

define auto_patches
	for p in $(PKG_PATCHES_DIR)/*.patch; do \
		echo -e "$(TERM_YELLOW)Applying patch $(PKG_NAME):$(TERM_NORMAL) `basename $$p`"; \
		patch -p1 -i $$p; \
	done
endef

# -----------------------------------------------------------------------------

#
# Manipulation of .config files based on the Kconfig infrastructure.
# Used by the BusyBox package, the Linux kernel package, and more.
#

define KCONFIG_ENABLE_OPT # (option, file)
	sed -i -e "/\\<$(1)\\>/d" $(2)
	echo '$(1)=y' >> $(2)
endef

define KCONFIG_SET_OPT # (option, value, file)
	sed -i -e "/\\<$(1)\\>/d" $(3)
	echo '$(1)=$(2)' >> $(3)
endef

define KCONFIG_DISABLE_OPT # (option, file)
	sed -i -e "/\\<$(1)\\>/d" $(2)
	echo '# $(1) is not set' >> $(2)
endef

# -----------------------------------------------------------------------------

#
# Case conversion macros.
#

[LOWER] := a b c d e f g h i j k l m n o p q r s t u v w x y z
[UPPER] := A B C D E F G H I J K L M N O P Q R S T U V W X Y Z

define caseconvert-helper
$(1) = $$(strip \
	$$(eval __tmp := $$(1))\
	$(foreach c, $(2),\
		$$(eval __tmp := $$(subst $(word 1,$(subst :, ,$c)),$(word 2,$(subst :, ,$c)),$$(__tmp))))\
	$$(__tmp))
endef

$(eval $(call caseconvert-helper,UPPERCASE,$(join $(addsuffix :,$([LOWER])),$([UPPER]))))
$(eval $(call caseconvert-helper,LOWERCASE,$(join $(addsuffix :,$([UPPER])),$([LOWER]))))

# -----------------------------------------------------------------------------

#
# $(1) = title
# $(2) = color
#	0 - Black
#	1 - Red
#	2 - Green
#	3 - Yellow
#	4 - Blue
#	5 - Magenta
#	6 - Cyan
#	7 - White
# $(3) = left|center|right
#
define draw_line
	printf '%.0s-' {1..$(shell tput cols)}; \
	if test "$(1)"; then \
		cols=$(shell tput cols); \
		length=$(shell echo $(1) | awk '{print length}'); \
		case "$(3)" in \
			*right)  let indent="length + 1" ;; \
			*center) let indent="cols - (cols - length) / 2" ;; \
			*left|*) let indent="cols" ;; \
		esac; \
		tput cub $$indent; \
		test "$(2)" && printf $$(tput setaf $(2)); \
		printf '$(1)'; \
		test "$(2)" && printf $$(tput sgr0); \
	fi; \
	echo
endef

# -----------------------------------------------------------------------------

archives-list:
	@rm -f $(BUILD_DIR)/$(@)
	@make -qp | grep --only-matching '^\$(ARCHIVE).*:' | sed "s|:||g" > $(BUILD_DIR)/$(@)

DOCLEANUP  ?= no
GETMISSING ?= no
archives-info: archives-list
	@grep --only-matching '^\$$(ARCHIVE).*:' make/bootstrap.mk | sed "s|:||g" | \
	while read target; do \
		found=false; \
		for makefile in package/*/*.mk; do \
			if grep -q "$$target" $$makefile; then \
				found=true; \
			fi; \
			if [ "$$found" = "true" ]; then \
				continue; \
			fi; \
		done; \
		if [ "$$found" = "false" ]; then \
			echo -e "[$(TERM_RED) !! $(TERM_NORMAL)] $$target"; \
		fi; \
	done;
	@echo "[ ** ] Unused archives for this build system"
	@find $(ARCHIVE)/ -maxdepth 1 -type f | \
	while read archive; do \
		if ! grep -q $$archive $(BUILD_DIR)/archives-list; then \
			echo -e "[$(TERM_YELLOW) rm $(TERM_NORMAL)] $$archive"; \
			if [ "$(DOCLEANUP)" = "yes" ]; then \
				rm $$archive; \
			fi; \
		fi; \
	done;
	@echo "[ ** ] Missing archives for this build system"
	@cat $(BUILD_DIR)/archives-list | \
	while read archive; do \
		if [ -e $$archive ]; then \
			#echo -e "[$(TERM_GREEN) ok $(TERM_NORMAL)] $$archive"; \
			true; \
		else \
			echo -e "[$(TERM_YELLOW) -- $(TERM_NORMAL)] $$archive"; \
			if [ "$(GETMISSING)" = "yes" ]; then \
				make $$archive; \
			fi; \
		fi; \
	done;
	@$(REMOVE)/archives-list

# -----------------------------------------------------------------------------

# FIXME - how to resolve variables while grepping makefiles?
patches-info:
	@echo "[ ** ] Unused patches"
	@for patch in package/*/patches/*; do \
		if [ ! -f $$patch ]; then \
			continue; \
		fi; \
		patch=$${patch##*/}; \
		found=false; \
		for makefile in package/*/*.mk; do \
			if grep -q "$$patch" $$makefile; then \
				found=true; \
			fi; \
			if [ "$$found" = "true" ]; then \
				continue; \
			fi; \
		done; \
		if [ "$$found" = "false" ]; then \
			echo -e "[$(TERM_RED) !! $(TERM_NORMAL)] $$patch"; \
		fi; \
	done;

# -----------------------------------------------------------------------------

#
# python helpers
#
PYTHON_BUILD = \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LDSHARED="$(TARGET_CC) -shared" \
	PYTHONPATH=$(TARGET_DIR)/$(PYTHON_BASE_DIR)/site-packages \
	CPPFLAGS="$(TARGET_CPPFLAGS) -I$(TARGET_DIR)/$(PYTHON_INCLUDE_DIR)" \
	$(HOST_DIR)/bin/python ./setup.py $(SILENT_Q) build --executable=/usr/bin/python

PYTHON_INSTALL = \
	CC="$(TARGET_CC)" \
	CFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	LDSHARED="$(TARGET_CC) -shared" \
	PYTHONPATH=$(TARGET_DIR)/$(PYTHON_BASE_DIR)/site-packages \
	CPPFLAGS="$(TARGET_CPPFLAGS) -I$(TARGET_DIR)/$(PYTHON_INCLUDE_DIR)" \
	$(HOST_DIR)/bin/python ./setup.py $(SILENT_Q) install --root=$(TARGET_DIR) --prefix=/usr

# -----------------------------------------------------------------------------

# target for testing only. not useful otherwise
everything: $(shell sed -n 's/^\$$.D.\/\(.*\):.*/\1/p' package/*/*.mk)

# -----------------------------------------------------------------------------

# print all present targets...
print-targets:
	@sed -n 's/^\$$.D.\/\(.*\):.*/\1/p; s/^\([a-z].*\):\( \|$$\).*/\1/p;' \
		`ls -1 package/*/*.mk | \
		sort -u | fold -s -w 65

# -----------------------------------------------------------------------------

rewrite-test:
	@printf "$(TERM_YELLOW)---> create rewrite-libdir.txt ... "
	$(shell grep ^libdir $(TARGET_DIR)/usr/lib/*.la > $(BUILD_DIR)/rewrite-libdir.txt)
	@printf "done\n$(TERM_NORMAL)"
	@printf "$(TERM_YELLOW)---> create rewrite-pkgconfig.txt ... "
	$(shell grep ^prefix $(TARGET_DIR)/usr/lib/pkgconfig/* > $(BUILD_DIR)/rewrite-pkgconfig.txt)
	@printf "done\n$(TERM_NORMAL)"
	@printf "$(TERM_YELLOW)---> create rewrite-dependency_libs.txt ... "
	$(shell grep ^dependency_libs $(TARGET_DIR)/usr/lib/*.la > $(BUILD_DIR)/rewrite-dependency_libs.txt)
	@printf "done\n$(TERM_NORMAL)"

# -----------------------------------------------------------------------------

neutrino-patch:
	@printf "$(TERM_YELLOW)---> create $(NEUTRINO) patch ... $(TERM_NORMAL)"
	$(shell cd $(SOURCE_DIR) && diff -Nur --exclude-from=$(HELPERS_DIR)/diff-exclude $(NEUTRINO).org $(NEUTRINO) > $(BUILD_DIR)/$(NEUTRINO)-$(DATE).patch)
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

libstb-hal-patch:
	@printf "$(TERM_YELLOW)---> create $(LIBSTB_HAL) patch ... $(TERM_NORMAL)"
	$(shell cd $(SOURCE_DIR) && diff -Nur --exclude-from=$(HELPERS_DIR)/diff-exclude $(LIBSTB_HAL).org $(LIBSTB_HAL) > $(BUILD_DIR)/$(LIBSTB_HAL)-$(DATE).patch)
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

neutrino%-patch \
libstb-hal%-patch:
	@printf "$(TERM_YELLOW)---> create $(subst -patch,,$@) patch .. $(TERM_NORMAL)"
	$(shell cd $(SOURCE_DIR) && diff -Nur --exclude-from=$(HELPERS_DIR)/diff-exclude $(subst -patch,,$@).org $(subst -patch,,$@) > $(BASE_DIR)/$(subst -patch,-$(DATE).patch,$@) ; [ $$? -eq 1 ] )
	@printf "$(TERM_YELLOW)done\n$(TERM_NORMAL)"

