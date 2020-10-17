# Use > instead of a tab as recipe prefixes.
.RECIPEPREFIX = >

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
