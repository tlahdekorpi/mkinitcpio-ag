mkinitcpio(5)

# NAME

mkinitcpio - configuration file

# SYNOPSIS

/etc/mkinitcpio/config, /usr/lib/mkinitcpio/config

# DESCRIPTION

A mkinitcpio configuration file defines several variables which describe
the contents of the image.

# VARIABLES

*HOOKS*
	Defines an array of install hooks which will be run during the build.
	Order is important when "init" hook is used, as it defines the order
	in which runscript hooks will be run during bootup.

*COMPRESSION*
	Defines an array of programs in order of preference to filter the
	generated image through. If unspecified this setting defaults to
	*pigz*, *gzip*, *lz4* and *xz* compressors. In order to create an
	uncompressed image, define this variable as *cat*.

*MODULES*
	Defines an array of additional modules which should be added to the image.
	Dependencies (including other modules and necessary firmware), will also be
	added to the image. At runtime, the modules in this array will be explicitly loaded.

*BINARIES*
	Defines an array of additional binaries which should be added to the
	image. These are assumed to be dynamic ELF binaries, necessary shared
	library dependencies will automatically be added. However, it is not
	considered an error to specify a non-ELF binary in this variable.

*FILES*
	Defines an array of additional files which should be added to the image.
	Files are added as is, and parent directories will be added if needed. Files
	specified in this variable will override previously added files of the same
	path.

# SEE ALSO

*mkinitcpio*(8)
