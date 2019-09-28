#
# set up target environment for other makefiles
#
# -----------------------------------------------------------------------------

# https://www.gnu.org/prep/standards/html_node/Directory-Variables.html
remove-dir             = /.remove
remove-bindir          = $(remove-dir)/bin
remove-sbindir         = $(remove-dir)/sbin
remove-libexecdir      = $(remove-dir)/libexec
remove-datarootdir     = $(remove-dir)/share
remove-datadir         = $(remove-datarootdir)
remove-sysconfdir      = $(remove-dir)/etc
remove-sharedstatedir  = $(remove-dir)/com
remove-localstatedir   = $(remove-dir)/var
remove-runstatedir     = $(remove-dir)/run
remove-includedir      = $(remove-dir)/include
remove-oldincludedir   = $(remove-includedir)
remove-docdir          = $(remove-datarootdir)/doc
remove-infodir         = $(remove-datarootdir)/info
remove-htmldir         = $(remove-docdir)
remove-dvidir          = $(remove-docdir)
remove-pdfdir          = $(remove-docdir)
remove-psdir           = $(remove-docdir)
remove-libdir          = $(remove-dir)/lib
remove-lispdir         = $(remove-datarootdir)/emacs/site-lisp
remove-localedir       = $(remove-datarootdir)/locale
remove-mandir          = $(remove-datarootdir)/man
remove-man1dir         = $(remove-mandir)/man1
remove-man2dir         = $(remove-mandir)/man2

# -----------------------------------------------------------------------------

# ca-certificates
CA_BUNDLE              = ca-certificates.crt
CA_BUNDLE_DIR          = /etc/ssl/certs
