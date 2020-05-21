`mkinitcpio-ag` is a fork of archlinux [mkinitcpio](https://github.com/archlinux/mkinitcpio) with more features, performance and opinions.

This fork breaks backwards compatibility with upstream hooks and is not a drop-in replacement.

## Incomplete list of changes to upstream
* All helper functions don't do anything outside of writing all operations to a file that is used by [archivegen](https://github.com/tlahdekorpi/archivegen) to generate the final image.
* Includes all commonly used hooks like systemd, mdraid, encrypt and lvm.
* All hooks work with both systemd and mkinitcpio init. (no sd-hook separation)
* All hooks work with alternate system roots, see `--rootfs` flag.
* Everything works on most distros. (fedora, centos, debian, ubuntu and archlinux tested)
* Removed presets, a feature more suitable to be implemented elsewhere.
* Install hooks are no longer separated to hooks and install directories.
* All config files are sourced to allow overriding defaults more easily.
* Install hook order is expected not to matter, autodetect is always run first if it exists somewhere in the hooks array.
* `base` hook is now called `init` and conflicts with `systemd`.
* `udev` hook is merged to `init`
* All man pages are written using scdoc instead of asciidoc.
* Image is generated to stdout by default (will refuse if stdout is terminal).
* Easy to add files, binaries, directories, etc from commandline.
* No verbose and colorful messages.
* All upstream reported bugs in the bz and gh are fixed.
* Allows for arbitrary users and groups without being run as root.
* Is expected to be run as non-root.
* Everything is reproducible.
* No libarchive.
* Can be easily used in pipes
```sh
# download all packages that the image is generated from
mkinitcpio -ab | awk '/^f/{print $2}' | xargs rpm -qf | grep -v 'not owned' | sort -u | xargs dnf download
```
* Significant performance gains due to hooks not doing anything other than writing to a single file.
```sh
$ time mkinitcpio -A systemd,modconf,block,filesystems,keyboard,fsck,mdadm_udev,sd-lvm2,sd-encrypt,sd-vconsole -c /dev/null -g /tmp/image -z cat > /dev/null
==> WARNING: Possibly missing firmware for module: wd719x

real	0m7.937s
user	0m5.022s
sys 	0m3.600s

$ time ./mkinitcpio -no systemd,modconf,block,filesystems,keyboard,fsck,mdraid,lvm,encrypt,vconsole > /tmp/image
warning: missing firmware: wd719x-risc.bin
warning: missing firmware: wd719x-wcs.bin

real	0m1.752s
user	0m1.617s
sys 	0m1.009s

# archive can be saved using -s and generated directly with archivegen for even more performance gains
$ time archivegen -fmt cpio -elf.{expand,fallback,once,concurrent} /tmp/mkinitcpio.MMajHS/archive > /dev/null

real	0m0.096s
user	0m0.076s
sys 	0m0.056s
```
