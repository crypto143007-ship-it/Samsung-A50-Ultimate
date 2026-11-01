# ULTIMATE PERFORMANCE A50

[VERIFIED-STATIC] UPA50 is an in-progress kernel project for the Samsung
Galaxy A50 (`a50`), based on the Exynos 9610 source in this repository. The
working baseline is the fork's `android-14.0` branch, Linux 4.14.194.

**Status:** [VERIFIED-STATIC] No validated UPA50 kernel build or release is available.
Kernel builds and toolchain handling run in GitHub Actions only. No
physical-device testing has been performed. Do not flash this branch.

[PROPOSED] The planned editions are Standard and KernelSU-Next. Standard must
exclude KernelSU, KernelSU-Next, and SuSFS; the KernelSU-Next edition will use
the official pinned component. These are requirements, not implemented or
verified behavior yet.

## Project information

- [Build process](BUILDING.md)
- [Installation and recovery](INSTALLATION.md)
- [Compatibility](COMPATIBILITY.md)
- [Current status and next actions](docs/STATUS.md)
- [Engineering decisions](docs/DECISIONS.md)
- [Upstream sources and licenses](docs/UPSTREAM_AND_LICENSES.md)
- [GPL-2.0 license](LICENSE)

The fork's `android-14.0` branch is the source baseline; UPA50 work is on
`upa50/main`. Preserve the existing source notices and GPL-2.0 obligations.
