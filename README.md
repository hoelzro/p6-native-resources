# Native::Resources

Boilerplate helper for bundling native code

# Synopsis

```perl6
# assume you're building a helper library named 'helper'

# in Build.pm at the root of your distribution
use Panda::Builder;
use Native::Resources::Build;

class Build is Panda::Builder {
    method build($workdir) {
        make($workdir, "$workdir/resources/lib", :libname<helper>);
    }
}

# in Makefile.in
all: resources/lib/libhelper%SO% %FAKESO%

# rest of Makefile rules

# in META.info
{
    ...other metadata...
    "resources": [
        "lib/libhelper.so",
        "lib/libhelper.dll",
        "lib/libhelper.dylib"
    ],
}

# in lib/Helper.pm (or whatever your module is called)
use Native::Resources;
use NativeCall;

our sub call_helper() is native(resource-lib('helper', :%?RESOURCES)) { * }
```

# Description

Most of the time when you use NativeCall, you can just refer to libraries
that your OS has installed by default. However, sometimes, you want to
bundle native libraries into your distribution. There are several reasons
for doing this, among them are:

  * You have no guarantee that a library will be installed, or that it will be
  of the correct version, so you bundle your own

  * You're wrapping C++ code, which is tricky (or sometimes impossible) to do
  with NativeCall, so you need to write some C code to wrap the C++ into
  something NativeCall can use

This distribution provides two modules to help reduce the boilerplate you
need to write for this situation. Native::Resources provides resource-lib,
which consults your distribution's resources and determines the correct
file to use. Native::Resources::Build provides a make subroutine meant to
be called from Build.pm at your distribution's root.

# Examples

[Linenoise](https://github.com/hoelzro/p6-linenoise)
[Xapian](https://github.com/hoelzro/p6-xapian)

# Subroutines

## Native::Resource

```perl6
sub resource-lib(
	Str $libname,
	:%RESOURCES
)
```

Returns a filename that corresponds to the given library (denoted by `$libname`). You need to pass your `%?RESOURCES` in so the sub knows where to look.

## Native::Resource::Build

```perl6
sub get-vars(
	|c is raw
)
```
A wrapper around [LibraryMake](https://github.com/retupmoca/P6-LibraryMake)'s `get-vars`.

```perl6
sub process-makefile(
	|c is raw
)
```
A wrapper around [LibraryMake](https://github.com/retupmoca/P6-LibraryMake)'s `process-makefile`.

```perl6
sub make(
	Str $folder,
	Str $destfolder,
	Str :$libname
)
```
Sets up a `Makefile` and runs `make`. `$folder` passed into `Panda::Builder.build`; `$destfolder` should be `f$folder/resources/lib"`, and `$libname` should be the name of your library without any prefixes or extensions.
