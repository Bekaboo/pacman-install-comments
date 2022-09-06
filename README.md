# Pacman Hook for Adding Comments to Explicitly Installed Packages

This is a post transaction hook for adding comments to explicitly installed packages through Arch Linux's package manager `pacman`.

The hook is triggered every time there's an installation or uninstallation and invokes a script to add or remove packages from a file to keep it up to date. In addition, if you have `neovim`/`vim`/`vi` installed, it will also open the list file so that you can add comments after each package; in addition you can press "n" to navigate to the next installed package if you have multiple installed in one time.

A list file of explicitly installed packages should look like this:

```
pkg_a    # comments
pkg_b    # ok if you have no comment
pkg_c
pkg_d    # comments
```
There must be no space before the package name, comments should be placed after the package name with one or more spaces/tabs.

**Notice:** You should not have more than one entry for the same package, else all entries of that package will be deleted!

## Installation

```bash
sudo ./install.sh
```

You may want to add `HooDir = /etc/pacman.d/hooks` to your pacman config file, though it is enabled by default.

## Uninstallation

```bash
sudo ./uninstall.sh
```
