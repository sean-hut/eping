# Use > instead of a tab as recipe prefixes.
.RECIPEPREFIX = >

################
# User variables
################

# Package directories
PACKAGE_LINT_DIRECTORY = "~/.emacs.d/straight/build/package-lint/"
DASH_DIRECTORY = "~/.emacs.d/straight/build/dash/"
S_DIRECTORY = "~/.emacs.d/straight/build/s/"

####################
# Internal variables
####################

# Files
eping = eping.el

# Arguments
emacs_batch_quick = --batch --quick

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
