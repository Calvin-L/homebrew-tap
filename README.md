# Calvin's Homebrew Tap

Miscellaneous Homebrew packages.

## Important Packages

 - [tlatools](https://lamport.azurewebsites.net/tla/tla.html), command-line
   tools for working with TLA+
 - [cvc5](https://cvc5.github.io/), an SMT solver
 - [nix](https://nixos.org/), a package manager (this is for bootstrapping Nix
   only; you'll want to install Nix with Nix and then uninstall this)

Also, some of my own projects:

 - [ezpsl](https://github.com/Calvin-L/ezpsl), a system modeling language
 - [retry-forever](https://github.com/Calvin-L/retry-forever)
 - [many-smt](https://github.com/Calvin-L/many-smt), an SMT solver wrapper

## Notes

I'm sort of paranoid about versioning, so the packages here are versioned
(except my own projects which are poorly-maintained), and I only add new
versions, never upgrade-in-place.  The unversioned names (e.g. `tlatools`) are
aliases for the latest version.

This does mean that sometimes you'll have to uninstall/reinstall a package to
update to the latest version, but your environment will be much more stable in
the meantime.
