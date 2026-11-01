# SOVR baseline

## Repository and tag identity

- [VERIFIED-STATIC] Canonical repository: `SOVR-Technologies/SOVR-Kernel-A50`.
  The `ruuiii-tk/SOVR-Kernel-A50` URL resolves to the same GitHub repository
  ID, `1389017067`.
- [VERIFIED-STATIC] The repository is not marked as a GitHub fork. The
  `v4.0` tag resolves to `98c776aae7ae2f41153e85d25a0f4336b1631316`;
  `v4.1-final` resolves to `195b69f9b4e71f7e9ce409feb47aca253021a68e`.
- [VERIFIED-STATIC] Nine SOVR tags are visible. A GitHub compare of the Mint
  tag `7f72a8b689677562f028d78b2e91bd79277a0aba` with SOVR `v4.0` reports
  `merge_base: null` and `status: diverged`; treat SOVR as a separate history,
  not a straightforward Mint descendant.
- [VERIFIED-STATIC] Both `v4.0` and `v4.1-final` declare Linux 4.14.357,
  `Petit Gorille`, in `Makefile`.

The full-history, all-ref filtered mirror did not complete: after more than
20 minutes it still had no received pack data and was stopped. Read-only,
depth-one, blob-filtered snapshots of all nine tags were acquired instead.
This limitation leaves the full history and ancestry review incomplete.

## Feature and configuration comparison

| Area | Mint `xbeta-1413_a50dx` | SOVR `v4.0` (also checked in `v4.1-final`) |
|---|---|---|
| Kernel release | 4.14.194 | 4.14.357 |
| Multi-Gen LRU | No `CONFIG_LRU_GEN` in A50 core config; no implementation found in `mm/vmscan.c` | `CONFIG_LRU_GEN=y` and `CONFIG_LRU_GEN_ENABLED=y` in A50 core config; implementation in `mm/vmscan.c` |
| ZRAM compression default | `CONFIG_ZRAM_DEF_COMP="lz4"` | `CONFIG_ZRAM_DEF_COMP="zstd"` with `CONFIG_ZRAM_DEF_COMP_ZSTD=y` |
| TCP congestion | BBR is compiled, but `CONFIG_DEFAULT_TCP_CONG="westwood"` | `CONFIG_DEFAULT_TCP_CONG="bbr"` and `CONFIG_TCP_CONG_BBR=y` |
| Default network scheduler | No CAKE implementation or config in the Mint tag | `CONFIG_DEFAULT_NET_SCH="cake"` and `CONFIG_NET_SCH_CAKE=y` |
| KPROBES | Disabled in the A50 core defconfig | Disabled in the A50 core defconfig |

SOVR config evidence is in
`arch/arm64/configs/exynos9610-a50_core_defconfig` (v4.0 lines 256, 653–655,
887, 894, 1189–1190, and 1396–1400). Mint evidence is in the corresponding
core defconfig at lines 260, 891, 898, and 1397–1401. The source baselines are
the exact tag commits listed above.

The v4.1 config retains the same MGLRU, BBR, CAKE, and ZSTD defaults. Its
config and `build.sh` differ from v4.0, while the two workflow files do not
change between these tags.

## KernelSU and SuSFS

- [VERIFIED-STATIC] SOVR v4.0 contains tracked in-tree KernelSU-related
  sources under `drivers/kernelsu/`; the root has no `.gitmodules` file.
- [VERIFIED-STATIC] `drivers/kernelsu/setup.sh` identifies
  `KernelSU-Next/KernelSU-Next`, performs an unpinned clone and `git pull`,
  then checks out either the latest tag or a requested ref and creates a
  symlink. This is not a reproducible version pin.
- [VERIFIED-STATIC] The SOVR `drivers/kernelsu/Kconfig` defines
  `KSU_MANUAL_HOOK`, defaulting it on when `KPROBES` is disabled. Official
  KernelSU-Next v3.4.2 instead requires `KPROBES && EXT4_FS` and does not
  define `CONFIG_KSU_MANUAL_HOOK`; copying SOVR's setting into that official
  release is not supported by the inspected Kconfig.
- [VERIFIED-STATIC] SuSFS is not limited to a config toggle. SOVR includes
  `fs/susfs.c`, `include/linux/susfs.h`,
  `include/linux/susfs_def.h`, and KSU integration under
  `drivers/kernelsu/`. Its core defconfig enables `CONFIG_KSU_SUSFS` and
  multiple `CONFIG_KSU_SUSFS_*` options (v4.0 lines 5788–5804); the menu is
  defined in `drivers/kernelsu/Kconfig` (lines 64–149).
- [PROPOSED] Do not import SOVR's KSU/SuSFS integration into UPA50 Standard.
  The Standard edition must remove both the code and config, and any separate
  KernelSU-Next edition must use a pinned official commit with verified hook
  compatibility. SuSFS remains out of scope.

## Build, SELinux, and release workflow findings

- [VERIFIED-STATIC] SOVR's core defconfig sets an enforcing-capable SELinux
  configuration and a `CONFIG_CMDLINE` without a permissive argument. This
  does not establish runtime enforcement. Its standalone
  `build.sh` boot-image command nevertheless adds
  `androidboot.selinux=permissive` twice (v4.0 line 289; v4.1 line 300).
- [VERIFIED-STATIC] The AnyKernel package uses `split_boot` and `flash_boot`
  from `tools/make/package/tools/ak3-core.sh` to repack the installed boot
  image. The inspected package scripts do not add the permissive cmdline;
  ZIP runtime SELinux mode is therefore unverified.
- [VERIFIED-STATIC] `build.sh` defaults to an `aosp_17` toolchain branch, but
  clones toolchains by branch/ref without a recorded checksum. The build is
  not reproducible from the script alone.
- [VERIFIED-STATIC] v4.0 and v4.1 retain inherited
  `.github/workflows/development.yml` and `galaxy-a50.yml` release jobs.
  They publish packages through `Hs1r1us/Release-AIO@v1.0` without a package
  content-validation step. The first is manually dispatched; the second
  targets `android-*`. The v4.1 tag does not update these workflows.
- [PROPOSED] Do not treat either SOVR workflow as a validated UPA50 release
  pipeline. The current UPA50 branch adds fail-closed archive checks to its
  inherited release jobs, but those checks have not run in Actions.

## Base-kernel decision

[PROPOSED] No base is selected. SOVR's newer 4.14.357 base and its MGLRU,
ZSTD, BBR default, and CAKE support are relevant static advantages, not build
or device evidence. Neither strategy has been configured and compiled with a
pinned toolchain, and device boot compatibility has not been tested.
