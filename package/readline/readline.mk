#
# readline
#
READLINE_VER    = 6.2
READLINE_DIR    = readline-$(READLINE_VER)
READLINE_SOURCE = readline-$(READLINE_VER).tar.gz
READLINE_URL    = https://ftp.gnu.org/gnu/readline

$(ARCHIVE)/$(READLINE_SOURCE):
	$(DOWNLOAD) $(READLINE_URL)/$(READLINE_SOURCE)

$(D)/readline: bootstrap $(ARCHIVE)/$(READLINE_SOURCE)
	$(START_BUILD)
	$(REMOVE)/$(READLINE_DIR)
	$(UNTAR)/$(READLINE_SOURCE)
	$(CHDIR)/$(READLINE_DIR); \
		$(CONFIGURE) \
			--prefix=/usr \
			--mandir=/.remove \
			--infodir=/.remove \
			--datadir=/.remove \
			bash_cv_must_reinstall_sighandlers=no \
			bash_cv_func_sigsetjmp=present \
			bash_cv_func_strcoll_broken=no \
			bash_cv_have_mbstate_t=yes \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(READLINE_DIR)
	$(TOUCH)
