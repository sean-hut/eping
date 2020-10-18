# Use > instead of a tab as recipe prefixes.
.RECIPEPREFIX = >

################
# User variables
################

# Package directories
ELISP_LINT_DIRECTORY = "~/.emacs.d/straight/build/elisp-lint/"
PACKAGE_LINT_DIRECTORY = "~/.emacs.d/straight/build/package-lint/"
DASH_DIRECTORY = "~/.emacs.d/straight/build/dash/"
S_DIRECTORY = "~/.emacs.d/straight/build/s/"

####################
# Internal variables
####################

# Files
eping = eping.el
compiled_elisp = eping.elc flycheck_eping.elc
autoloaded_elisp = eping-autoloads.el eping-autoloads.el~
texinfo = eping.texinfo
info_file = eping.info
html_directory = docs/

# Arguments
emacs_batch_quick = --batch --quick
emacs_batch = --batch
rm_options = -f

all : lint-elisp lint-git-whitespace clean documentation

lint-elisp : lint-byte-compile lint-checkdoc lint-elisp-lint

lint-byte-compile : $(eping)
> emacs $(emacs_batch_quick) \
> --eval='(setq byte-compile-warnings t)' \
> --eval='(setq byte-compile-error-on-warn t)' \
> --eval='(byte-compile-file "$(eping)")'

lint-checkdoc : $(eping)
> emacs $(emacs_batch_quick) --eval='(checkdoc-file "$(eping)")'

# pakace-lint does not work with straight package manager
# Use package-lint through elisp-lint
# because of package-lint issue #153
# https://github.com/purcell/package-lint/issues/153
# lint-package-lint : $(eping)
#> emacs $(emacs_batch) \
#> --directory=$(PACKAGE_LINT_DIRECTORY) \
#> --directory=$(DASH_DIRECTORY) \
#> --directory=$(S_DIRECTORY) \
#> --load="package-lint.el" \
#> --eval='(setq package-lint-batch-fail-on-warnings t)' \
#> --funcall=package-refresh-contents \
#> --funcall=package-lint-batch-and-exit \
#> $(eping)

lint-elisp-lint : $(eping)
> emacs $(emacs_batch) \
> --directory=$(ELISP_LINT_DIRECTORY) \
> --directory=$(PACKAGE_LINT_DIRECTORY) \
> --directory=$(DASH_DIRECTORY) \
> --directory=$(S_DIRECTORY) \
> --load="elisp-lint.el" \
> --load="package-lint.el" \
> --eval='(setq fill-column 70)' \
> --eval='(setq indent-tabs-mode nil)' \
> --funcall=elisp-lint-files-batch \
> $(eping)

lint-git-whitespace :
> git diff --check

documentation : documentation-info documentation-html

documentation-info : $(texinfo)
> makeinfo --output=$(info_file) $(texinfo)

documentation-html : $(texinfo)
> makeinfo --html --output=$(html_directory) $(texinfo)

.PHONY: clean
clean : clean-elisp clean-documentation

.PHONY: clean-elisp
clean : clean-compiled-elisp clean-autoloaded-elisp

.PHONY: clean-compiled-elisp
clean-compiled-elisp :
> rm $(rm_options) $(compiled_elisp)

.PHONY: clean-autoloaded-elisp
clean-autoloaded-elisp :
> rm $(rm_options) $(autoloaded_elisp)

.PHONY: clean-documentation
clean : clean-info clean-html

.PHONY: clean-info
clean-info :
> rm $(rm_options) $(info_file)

.PHONY: clean-html
clean-html :
> rm $(rm_options) $(html_directory)*
