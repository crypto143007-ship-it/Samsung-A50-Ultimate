# ULTIMATE PERFORMANCE A50 (UPA50)

Independent kernel engineering for Samsung Galaxy A50 (`a50`), based on the
Samsung Exynos 9610 kernel source in this repository.

> **Development status:** [VERIFIED-STATIC] This branch is a project-integration
> branch based on `android-14.0`. It is not a validated kernel build. No release
> artifacts or physical-device results are available.

## Repository baseline

- [VERIFIED-STATIC] Repository:
  [`crypto143007-ship-it/Samsung-A50-Ultimate`](https://github.com/crypto143007-ship-it/Samsung-A50-Ultimate)
- [VERIFIED-STATIC] Device tree: `a50`
- [VERIFIED-STATIC] Kernel version at the fork baseline: Linux 4.14.194,
  `Petit Gorille`
- [VERIFIED-STATIC] Fork baseline commit:
  `bec0c2aff1ee8a02ac9f582d60fe611f1d2bc939`
- [VERIFIED-STATIC] License: GPL-2.0; see `COPYING`

[VERIFIED-STATIC] The fork's default `android-14.0` branch is retained as the
upstream comparison baseline. UPA50 work is being done on `upa50/main`.
[PROPOSED] Base-kernel selection and Android/ROM compatibility remain under
investigation; see
[`docs/PROJECT_STATUS.md`](docs/PROJECT_STATUS.md) and
[`docs/upstream-analysis/`](docs/upstream-analysis/).

## Evidence labels

Every project claim must use one of these labels:

- `[VERIFIED-DEVICE]` — tested on physical Galaxy A50 hardware, with conditions and raw results
- `[VERIFIED-BUILD]` — confirmed by a real kernel build or CI run
- `[VERIFIED-STATIC]` — confirmed by source, configuration, or static inspection
- `[SIMULATED]` — emulator or synthetic test only
- `[PROPOSED]` — not implemented or not yet tested

## Safety and support

[VERIFIED-STATIC] No unsupported frequency or voltage changes have been made
on this branch.
[PROPOSED] Future profiles must preserve thermal, charging, and battery
protections. Device variants, ROM support, boot behavior, SELinux mode, and
hardware compatibility are not yet established. Do not flash this development
branch.

## Build and installation

[PROPOSED] Reproducible build and installation instructions will be published
only after the source comparison, pinned toolchain selection, and artifact
validation are complete. No UPA50 release is currently available.

## Upstream attribution

[VERIFIED-STATIC] UPA50 is derived from the FreshROMs Mint Exynos9610 kernel
fork. Preserve its source history, notices, and GPL-2.0 obligations. Mint's
contributor acknowledgments are retained below; additional imports will be
listed in `docs/IMPORTED_PATCHES.md`.

### Mint source references and contributors

[VERIFIED-STATIC] The Mint kernel source acknowledges the following projects
and contributors:

- [Cruel Kernel for Galaxy S10/Note10](https://github.com/CruelKernel/samsung-exynos9820/) (@evdenis)
- [GaltsGulch for OnePlus 7](https://github.com/RealJohnGalt/GaltsGulch-sm8150) (@RealJohnGalt)
- [DragonHeart Kernel for OnePlus 7](https://github.com/cyberknight777/dragonheart_kernel_oneplus_sm8150) (@cyberknight777)
- [Sultan Kernel for Pixel 4](https://github.com/kerneltoast/android_kernel_google_floral) (@kerneltoast)
- [ThunderStorms Kernel for Galaxy S10/Note10](https://github.com/ThunderStorms21th/Galaxy-S10) (@ThunderStorms21th)
- [Cosmic Fresh for Moto G40 Fusion](https://github.com/Dark-Matter7232/CosmicFresh-Hanoip) (@Dark-Matter7232)
- [Motorola One Action/Vision kernel sources](https://github.com/MotorolaMobilityLLC/kernel-slsi)
- [Quantum Kernel](https://github.com/prashantpaddune/android_kernel_samsung_a50dd) (@prashantpaddune)
- [Zeus Kernel for Galaxy Note9](https://github.com/THEBOSS619/Note9-Zeus-Q10.0) (@THEBOSS619)
- [Custom Galaxy A51 Kernel](https://github.com/ianmacd/a51xx) (@ianmacd)
- [StormBreaker](https://github.com/stormbreaker-project/kernel_xiaomi_surya) and [Stratosphere](https://github.com/Stratosphere-Kernel/android_kernel_xiaomi_surya) for POCO X3
- [Artemis Kernel for Pixel 4 XL](https://github.com/celtare21/kernel_google_coral) (@celtare21)
- [GS101/Tensor SoC kernel source](https://github.com/AndreiLux/GS101) (@Google/@AndreiLux)

[VERIFIED-STATIC] This list reflects the source README at the fork baseline;
it is not a complete provenance inventory for all files in the kernel tree.
