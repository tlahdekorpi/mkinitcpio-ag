mkinitcpio.init(5)

# NAME

mkinitcpio /init

# DESCRIPTION

mkinitcpio init hook is a shell script that sets up the root filesystem
and allows for easy extension with runscript hooks.

# RUNTIME HOOKS

Runtime hooks are added to the image by creating a file called _runscript_ in
the install hook directory. A hook can define specific functions that are run
at different times. Hooks are run in the order they are defined in the HOOKS
variable, except for cleanup hooks which are run in reverse.

*run_earlyhook*
	Functions of this name will be run once the API mounts have been setup and the
	kernel command line has been parsed. Daemons needed for early userspace should
	be started from this hook point.

*run_hook*
	Functions of this name will be run after any early hooks, and after user
	defined modules have been loaded. This is the most common hook point, and
	functionality such as scanning for LVM volumes and mapping encrypted volumes
	should be performed here.

*run_latehook*
	Functions of this name will be run after the root filesystem has been
	mounted at /sysroot. This is generally used for further necessary setup
	in /sysroot, such as mounting other system partitions.

*run_cleanuphook*
	Functions of this name are run as late as possible. Any daemons started
	from a run_earlyhook function should be shut down here in preparation for
	switching to the real root at /sysroot.

# KERNEL COMMAND LINE

_break=_, _rd.break=_
	Start a shell during early init at a specific breakpoint.
	Argument must be one of "premount", "postmount". If the argument is
	omitted, it defaults to "premount".

_disablehooks=_
	Skip hooks. The argument should be a comma-separated list.

_earlymodules=_, _rd.modules_load=_
	Takes a comma-separated list of kernel modules to load during early boot.
	This is generally not needed, and usually points to a configuration
	or kernel problem.

_quiet_
	Output fewer messages during boot.

_ro_, _rw_
	Mount /sysroot as read-only or read-write. Defaults to _ro_.
	Read-write is generally only useful if your image uses the "fsck" hook.

_root=_
	Device mounted at /sysroot. This can be in a variety of formats such as
	the most basic of which is the path to the block device, either
	directly such as "/dev/sda2", using a udev symlink such as "/dev/disk/by-label/root",
	or identification by LABEL, UUID, PARTUUID and PARTLABEL tags.
	Identification via hex encoded major/minor device ID is supported for legacy reasons, but
	should be avoided as it tends to be fragile.

	PARTUUID and PARTLABEL are only supported as of util-linux 2.22.

_rootdelay=_
	Timeout waiting for root device to show up, if it's not available
	immidiately. The argument should be a duration in seconds.
	Defaults to 10s.

_rootflags=_
	Options passed to *mount*(8) for the root filesystem.
	The argument should be a comma-separated list.

_rootfstype=_
	Filesystem type for /sysroot, this should not be needed as
	*mount*(8) should detect this on its own.

_rd.debug_
	Enables shell debug (xtrace). If _rd.log_ is not also a parameter on the kernel
	command line, this parameter implies _rd.log=console_.

_rd.log=_
	Log early userspace messages. The argument should be a "|" separated
	list of targets. Messages are always logged to console unless used with _quiet_.
	Defaults to "kmsg|console".

	_kmsg_ target is a no-op if your kernel lacks support for */dev/kmsg*.

[] Target
:- Description
|   console
:[ Output to */dev/console*
|   file
:[ Output to */run/initramfs/init.log*
|   kmsg
:[ Output to the */dev/kmsg* (Linux 3.5+).
|   all
:[ Output to all targets.


# SEE ALSO

*mkinitcpio*(8), *mkinitcpio*(5)
