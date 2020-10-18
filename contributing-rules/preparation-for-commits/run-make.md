# Run Make

Run `make` on your changes and fix any errors or warnings before you
commit your changes.

If you are not using the [straight package manager][straight] for your
Emacs packages you will need to run something like this instead.

```
make \
ELISP_LINT_DIRECTORY = "~/path/to/elisp-lint/directory/" \
PACKAGE_LINT_DIRECTORY = "~/path/to/package-lint/directory/" \
DASH_DIRECTORY = "~/path/to/dash/directory/" \
S_DIRECTORY = "~/path/to/s/directory/"
```

[straight]: <https://github.com/raxod502/straight.el>
