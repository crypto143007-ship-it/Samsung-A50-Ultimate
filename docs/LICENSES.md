# License and provenance

## Kernel source

[VERIFIED-STATIC] The repository includes the Linux kernel `COPYING` file.
Kernel-source changes and distributions must comply with the applicable
GPL-2.0 terms and preserve source notices, copyright, and authorship.

## Build scripts and third-party components

[VERIFIED-STATIC] The existing `build.sh` header identifies its authors and
states GPL version 3 or (at your option) any later version. Keep that header
intact and treat the build script as a separately licensed component.
Licenses for bundled packaging tools have not yet been audited. Do not infer
the license of one component from the kernel's license.

[PROPOSED] Before distributing a binary, record the provenance, license,
version, and checksum for every bundled tool and packaging component, or build
it from a documented source.

## Current status

[VERIFIED-STATIC] No UPA50 binary or third-party prebuilt artifact has been
distributed.
